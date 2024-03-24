//
//  GetItemsResponse.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation
import ObjectMapper

final class GetItemsResponse: Mappable {
    
    var siteId:                 String?
    var countryDefaultTimeZone: String?
    var paging:                 PagingInfo?
    var results:                [MeLiItem] = []
    var sort:                   SortType?
    var availableSorts:         [SortType] = []
//    var filters
//    var availableFilters
//    var pdpTracking
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        siteId                 <- map["site_id"]
        countryDefaultTimeZone <- map["country_default_time_zone"]
        paging                 <- map["paging"]
        results                <- map["results"]
        sort                   <- map["sort"]
        availableSorts         <- map["available_sorts"]
//        filters                <- map["filters"]
//        availableFilters       <- map["available_filters"]
//        pdpTracking            <- map["pdp_tracking"]
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

final class SortType: Mappable, Equatable {
    
    var id:   String?
    var name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
    
    static func == (lhs: SortType, rhs: SortType) -> Bool {
        return lhs.id == rhs.id
    }
}
