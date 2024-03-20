//
//  GetItemsResponse.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation

final class GetItemsResponse: NSObject, Decodable {
    
    var siteId:                 String?
    var countryDefaultTimeZone: String?
    var paging:                 PagingInfo?
    var results:                [MeLiItem] = []
    var sort:                   SortType?
    var availableSorts:         [SortType] = []
//    var filters
//    var availableFilters
//    var pdpTracking
    
    enum CodingKeys: String, CodingKey {
        case siteId                 = "site_id"
        case countryDefaultTimeZone = "country_default_time_zone"
        case paging                 = "paging"
        case results                = "results"
        case sort                   = "sort"
        case availableSorts         = "available_sorts"
        case filters                = "filters"
        case availableFilters       = "available_filters"
        case pdpTracking            = "pdp_tracking"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(String.self, forKey: .id)
//        name = try container.decodeIfPresent(String.self, forKey: .name)
//        username = try container.decodeIfPresent(String.self, forKey: .username)
//        birthday = try container.decodeIfPresent(String.self, forKey: .birthday)
    }
}

final class PagingInfo: NSObject, Decodable {
    
    var total:           Int?
    var primary_results: Int?
    var offset:          Int?
    var limit:           Int?
    
    enum CodingKeys: String, CodingKey {
        case total           = "total"
        case primary_results = "primary_results"
        case offset          = "offset"
        case limit           = "limit"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total           = try container.decodeIfPresent(Int.self, forKey: .total)
        primary_results = try container.decodeIfPresent(Int.self, forKey: .primary_results)
        offset          = try container.decodeIfPresent(Int.self, forKey: .offset)
        limit           = try container.decodeIfPresent(Int.self, forKey: .limit)
    }
}

final class SortType: NSObject, Decodable {
    
    var id:   String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id   = "id"
        case name = "name"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id   = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}

//{
//    "site_id": "MLA",
//    "country_default_time_zone": "GMT-03:00",
//    "paging": {
        
//    },
//    "results": [],
//    "sort": {
        
//    },
//    "available_sorts": [
//        {
//            "id": "price_asc",
//            "name": "Menor precio"
//        },
//        {
//            "id": "price_desc",
//            "name": "Mayor precio"
//        }
//    ],
//    "filters": [],
//    "available_filters": [],
//    "pdp_tracking": {
//        "group": false,
//        "product_info": []
//    }
//}
