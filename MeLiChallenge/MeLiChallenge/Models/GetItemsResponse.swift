//
//  GetItemsResponse.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 19/03/2024.
//

import Foundation
import ObjectMapper
import RxSwift

final class GetItemsResponse: Mappable {
    
    var siteId:                 String?
    var countryDefaultTimeZone: String?
    var paging:                 PagingInfo?
    var results:                [MeLiItem] = []
    var sort:                   SortType?
    var availableSorts:         [SortType] = []
    var filters:                [GetItemsFilter] = []
    var availableFilters:       [GetItemsFilter] = []
//    var pdpTracking
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        siteId                 <- map["site_id"]
        countryDefaultTimeZone <- map["country_default_time_zone"]
        paging                 <- map["paging"]
        results                <- map["results"]
        sort                   <- map["sort"]
        availableSorts         <- map["available_sorts"]
        filters                <- map["filters"]
        availableFilters       <- map["available_filters"]
//        pdpTracking            <- map["pdp_tracking"]
        
        sort?.isSelected = true
        filters.forEach { $0.values.forEach { $0.isSelected = true } }
    }
}

final class PagingInfo: Mappable {
    
    var total:          Int?
    var primaryResults: Int?
    var offset:         Int?
    var limit:          Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        total          <- map["total"]
        primaryResults <- map["primary_results"]
        offset         <- map["offset"]
        limit          <- map["limit"]
    }
}

final class SortType: NSObject, Mappable {
    
    var id:   String?
    var name: String?
    
    @objc dynamic var isSelected: Bool = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
    
    static func == (lhs: SortType, rhs: SortType) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Reactive where Base: SortType {
    var isSelectedRx: Observable<Bool> {
        return self.base.rx.observe(Bool.self, "isSelected").compactMap { $0 }
    }
}

final class GetItemsFilter: NSObject, Mappable {
    
    var id:     String?
    var name:   String?
    var type:   FilterType?
    var values: [FilterValue] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id     <- map["id"]
        name   <- map["name"]
        type   <- map["type"]
        values <- map["values"]
    }
    
    enum FilterType: String {
        case text
        case boolean
        case range
    }
}

//  Getters
extension GetItemsFilter {
    var isSelected: Bool {
        return values.contains(where: { $0.isSelected == true }) == true
    }
}

final class FilterValue: NSObject, Mappable {
    var id:      String?
    var name:    String?
    var results: Int?
    
    @objc dynamic var isSelected: Bool = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        results <- map["results"]
    }
}

extension Reactive where Base: FilterValue {
    var isSelectedRx: Observable<Bool> {
        return self.base.rx.observe(Bool.self, "isSelected").compactMap { $0 }
    }
}
