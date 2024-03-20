//
//  Requests.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation

enum Requests {
    static private var baseURL: String { return "https://api.mercadolibre.com" }
    static private var siteId: String { return "MLA" }
    
    static var apisBaseURL: String { return baseURL + "/sites/" + siteId }
}

extension Requests {
    enum Items {}
    enum Categories {}
}
