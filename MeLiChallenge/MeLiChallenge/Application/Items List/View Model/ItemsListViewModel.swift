//
//  ItemsListViewModel.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 20/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension ItemsListViewController {
    final class ViewModel {
        private let disposeBag = DisposeBag()
        
        let loading = LoadingRelay()
        
        let keyword:  BehaviorRelay<String?>
        let category: BehaviorRelay<MeLiCategory?>
        let selectedSort: BehaviorRelay<SortType?>
        
        let itemsResponse = BehaviorRelay<GetItemsResponse?>(value: nil)
        let items = BehaviorRelay(value: [MeLiItem]())
        
        init(category: MeLiCategory? = nil) {
            self.keyword  = .init(value: nil)
            self.category = .init(value: category)
            self.selectedSort = .init(value: nil)
            
            Observable
                .combineLatest(
                    keyword.distinctUntilChanged(),
                    self.category.distinctUntilChanged(),
                    selectedSort.skip(2).distinctUntilChanged()
                )
                .skip(1)
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] _ in
                        self?.getItems()
                    }
                )
                .disposed(by: disposeBag)
            
            getItems()
            
            itemsResponse
                .subscribe(
                    onNext: { [weak self] itemsResponse in
                        self?.items.accept(itemsResponse?.results ?? [])
                        self?.selectedSort.accept(itemsResponse?.sort)
                    }
                )
                .disposed(by: disposeBag)
        }
        
        func getItems() {
            let apiRequest = Requests.Items.Get(
                keyword:  keyword.value,
                category: category.value?.id
            )
            
            loading.requestStarted()
            
            apiRequest
                .apiCall(model: GetItemsResponse.self)
                .subscribe(
                    onSuccess: { [weak self] itemsResponse in
                        self?.loading.requestFinished()
                        self?.itemsResponse.accept(itemsResponse)
                    },
                    onFailure: { [weak self] error in
                        self?.loading.requestFinished()
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}
