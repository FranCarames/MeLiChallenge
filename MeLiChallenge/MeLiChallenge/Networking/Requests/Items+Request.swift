//
//  Items.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 19/03/2024.
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
        let sortType: SortType?
        let filters:  [GetItemsFilter]?
        
        var parameters: Parameters {
            var params = [
                "q"         : keyword,
                "category"  : category,
                "nickname"  : nickname,
                "seller_id" : sellerId,
                "sort"      : sortType?.id
            ]
            
            filters?
                .forEach({ filter in
                    guard
                        let filterId = filter.id,
                        let selectedValueId = filter.values.first(where: { $0.isSelected == true })?.id
                    else { return }
                    
                    params[filterId] = selectedValueId
                })
            
            return params
        }
        
        var request: RequestData {
            return RequestData(
                endpoint:   "/search",
                parameters: parameters
            )
        }
        
        init(keyword: String? = nil, category: String? = nil, nickname: String? = nil, sellerId: String? = nil, sortType: SortType? = nil, filters: [GetItemsFilter]? = nil) {
            self.keyword  = keyword
            self.category = category
            self.nickname = nickname
            self.sellerId = sellerId
            self.sortType = sortType
            self.filters  = filters
        }
    }
}
