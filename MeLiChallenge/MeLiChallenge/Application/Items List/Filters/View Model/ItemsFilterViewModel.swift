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
        
        private let selectedSort:     SortType
        private let availableSorts:   [SortType]
        var selectedFilters:  [GetItemsFilter] // hacer lo mismo que con los sort y ya lo tenes champ
        var availableFilters: [GetItemsFilter]
        
        private(set) var sorts: [SortType]
        private(set) var filters: [GetItemsFilter]
        
        var isSectionOpen: [Bool]
        
        init(selectedSort: SortType, availableSorts: [SortType],
             selectedFilters:  [GetItemsFilter], availableFilters: [GetItemsFilter]) {
            self.selectedSort     = selectedSort
            self.availableSorts   = availableSorts
            self.selectedFilters  = selectedFilters
            self.availableFilters = availableFilters
            
            self.sorts   = [selectedSort] + availableSorts
            self.filters = selectedFilters + availableFilters
            
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
        
        func getCellType(for section: Int) -> FilterSections {
            if section == 0 {
                return .sortType
            } else {
                return .filters
            }
        }
        
        func numberOfRows(in section: Int) -> Int {
            switch getCellType(for: section) {
            case .sortType:
                return isSectionOpen[section] ? sorts.count : 0
            case .filters:
//                TODO agregar +1 para las borrar el filtro
                return isSectionOpen[section] ? filters[getCorrectedIndex(for: section)].values.count : 0
            }
        }
        
        func getCorrectedIndex(for section: Int) -> Int {
            switch getCellType(for: section) {
            case .sortType:
                return 0
            case .filters:
                let correctedIndex = section - 1
                return correctedIndex
            }
        }
        
        func newSortSelected(at index: Int) {
            let oldActiveSort = sorts.first(where: { $0.isSelected == true })
            let newSelectedSort = sorts[index]
            
            if oldActiveSort != newSelectedSort {
                oldActiveSort?.isSelected = false
                newSelectedSort.isSelected = true
            }
        }
        
        func newFilterSelected(at indexPath: IndexPath) {
            let index = getCorrectedIndex(for: indexPath.section)
            let filter = filters[index]
            let oldActiveValue = filter.values.first(where: { $0.isSelected == true })
            let newSelectedValue = filter.values[indexPath.row]

            if oldActiveValue != newSelectedValue {
                oldActiveValue?.isSelected = false
                newSelectedValue.isSelected = true
            }
        }
        
        func resetFiltersTapped() {
            sorts.forEach { $0.isSelected = false }
            sorts.first?.isSelected = true
            
//            filr
        }

        enum FilterSections {
            case sortType
            case filters
        }
    }
}
