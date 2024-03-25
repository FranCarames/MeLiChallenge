//
//  Items.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation

extension Requests.Items {
    struct Get: NetworkRequestType {
        var identifier:  String { "Get Items" }
        var logDispatch: Bool   { true }
        var logResponse: Bool   { true }
        
        let keyword:  String?
        let category: String?
        let nickname: String?
        let sellerId: String?
        var sortType: SortType?
        
        var parameters: Parameters {
            return [
                "q"         : keyword,
                "category"  : category,
                "nickname"  : nickname,
                "seller_id" : sellerId,
                "sort"      : sortType?.id
            ]
        }
        
        var request: RequestData {
            return RequestData(
                endpoint:   "/search",
                parameters: parameters
            )
        }
        
        init(keyword: String? = nil, category: String? = nil, nickname: String? = nil, sellerId: String? = nil, sortType: SortType? = nil) {
            self.keyword  = keyword
            self.category = category
            self.nickname = nickname
            self.sellerId = sellerId
            self.sortType = sortType
        }
    }
}
