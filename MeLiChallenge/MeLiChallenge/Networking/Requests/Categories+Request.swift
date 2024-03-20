//
//  Categories+Request.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 20/03/2024.
//

import Foundation

extension Requests.Categories {
    struct Get: NetworkRequestType {
        var identifier:  String { "Get Categories" }
        var logDispatch: Bool   { true }
        var logResponse: Bool   { true }
        
        var request: RequestData {
            return RequestData(
                endpoint: "/categories"
            )
        }
    }
}
