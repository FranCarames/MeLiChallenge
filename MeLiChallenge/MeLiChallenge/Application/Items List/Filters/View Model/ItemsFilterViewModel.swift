//
//  ItemsFilterViewModel.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension ItemsFilterViewController {
    final class ViewModel {
        private let disposeBag = DisposeBag()
        
        let availableFilters: [GetItemsFilter]
        
//        var selectedFilters: [GetItemsFilter]
        
        init(availableFilters: [GetItemsFilter]) {
            self.availableFilters = availableFilters
            
//            self.selectedFilters = availableFilters
//            selectedFilters.forEach { }
        }
    }
}
