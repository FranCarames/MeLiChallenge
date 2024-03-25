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
        let category: MeLiCategory
        
        let itemsResponse = BehaviorRelay<GetItemsResponse?>(value: nil)
        let items = BehaviorRelay(value: [MeLiItem]())
        
        init(category: MeLiCategory) {
            self.keyword  = .init(value: nil)
            self.category = category
            
            keyword.distinctUntilChanged()
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
                    }
                )
                .disposed(by: disposeBag)
        }
        
        func getItems(selectedSort: SortType? = nil, selectedFilters: [GetItemsFilter]? = nil) {
            let apiRequest = Requests.Items.Get(
                keyword:  keyword.value,
                category: category.id,
                sortType: selectedSort
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
