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
        
        var parameters: Parameters {
            return [
                "q"         : keyword,
                "category"  : category,
                "nickname"  : nickname,
                "seller_id" : sellerId
            ]
        }
        
        var request: RequestData {
            return RequestData(
                endpoint:   "/search",
                parameters: parameters
            )
        }
        
        init(keyword: String? = nil, category: String? = nil, nickname: String? = nil, sellerId: String? = nil) {
            self.keyword  = keyword
            self.category = category
            self.nickname = nickname
            self.sellerId = sellerId
        }
    }
}
