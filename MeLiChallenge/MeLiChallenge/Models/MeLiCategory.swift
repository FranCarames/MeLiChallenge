//
//  MeLiCategory.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 20/03/2024.
//

import Foundation
import ObjectMapper

final class MeLiCategory: Mappable {
    
    var id:   String?
    var name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
}
