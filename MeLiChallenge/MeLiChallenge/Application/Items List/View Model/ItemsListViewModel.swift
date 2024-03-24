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
        
        private var category: MeLiCategory?
        
        private let itemsResponse = BehaviorRelay<GetItemsResponse?>(value: nil)
        let items = BehaviorRelay(value: [MeLiItem]())
        
        init(category: MeLiCategory? = nil) {
            self.category = category
            
            getItems()
            
            itemsResponse
                .subscribe(
                    onNext: { [weak self] itemsResponse in
                        self?.items.accept(itemsResponse?.results ?? [])
                    }
                )
                .disposed(by: disposeBag)
        }
        
        func getItems() {
            let apiRequest = Requests.Items.Get(category: category?.id)
            
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
