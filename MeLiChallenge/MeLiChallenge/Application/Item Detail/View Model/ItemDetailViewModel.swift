//
//  ItemDetailViewModel.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension ItemDetailViewController {
    final class ViewModel {
        private let disposeBag = DisposeBag()
        
        let loading = LoadingRelay()
        
        let item: MeLiItem
        
        let sellerItems = BehaviorRelay(value: [MeLiItem]())
        
        var itemImages: [String] {
            return item.itemImageURLs ?? [item.thumbnail ?? ""]
        }
        
        init(item: MeLiItem) {
            self.item = item
            
            getSellerItems()
        }
        
        func getSellerItems() {
            guard let sellerId = item.seller?.id else { return }
            
            let apiRequest = Requests.Items.Get(sellerId: String(sellerId))
            
            loading.requestStarted()
            
            apiRequest
                .apiCall(model: GetItemsResponse.self)
                .subscribe(
                    onSuccess: { [weak self] itemsResponse in
                        self?.loading.requestFinished()
                        self?.sellerItems.accept(itemsResponse.results)
                    },
                    onFailure: { [weak self] error in
                        self?.loading.requestFinished()
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}

//final class ViewModel {
//    
//    private let itemsResponse = BehaviorRelay<GetItemsResponse?>(value: nil)
//    
    
//}
