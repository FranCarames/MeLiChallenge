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
        
        var selectedSort: SortType
        var availableSorts: [SortType]
        var selectedFilters:  [GetItemsFilter]
        var availableFilters: [GetItemsFilter]
        
        var isSectionOpen: [Bool]
        
        init(selectedSort: SortType, availableSorts: [SortType],
             selectedFilters:  [GetItemsFilter], availableFilters: [GetItemsFilter]) {
            self.selectedSort     = selectedSort
            self.availableSorts   = availableSorts
            self.selectedFilters  = selectedFilters
            self.availableFilters = availableFilters
            
            let sortTypeCount = 1
            let selectedFiltersCount = selectedFilters.count
            let filtersCount = availableFilters.count
            let sectionsCount = sortTypeCount + selectedFiltersCount + filtersCount
            
            isSectionOpen = (1...sectionsCount).map({ _ in return false })
        }
        
        func numberOfSetions() -> Int {
            let sortTypeCount = 1
            let selectedFiltersCount = selectedFilters.count
            let filtersCount = availableFilters.count
            
            return sortTypeCount + selectedFiltersCount + filtersCount
        }
        
        func getCellType(for section: Int) -> FilterCellType {
            if section == 0 {
                return .sortType
            } else if section <= selectedFilters.count {
                return .selectedFilter
            } else {
                return .filter
            }
        }
        
        func numberOfRows(in section: Int) -> Int {
            switch getCellType(for: section) {
            case .sortType:
                return isSectionOpen[section] ? 1 + availableSorts.count : 0
            case .selectedFilter:
                return isSectionOpen[section] ? 1 + selectedFilters[getCorrectedIndex(for: section)].values.count : 0
            case .filter:
                return isSectionOpen[section] ? availableFilters[getCorrectedIndex(for: section)].values.count : 0
            }
        }
        
        func getCorrectedIndex(for section: Int) -> Int {
            switch getCellType(for: section) {
            case .sortType:
                return 0
            case .selectedFilter:
                let correctedIndex = section - 1
                return correctedIndex
            case .filter:
                let correctedIndex = section - selectedFilters.count - 1
                return correctedIndex
            }
        }

        enum FilterCellType {
            case sortType
            case selectedFilter
            case filter
        }
    }
}
