//
//  MeLiCategory.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 20/03/2024.
//

import Foundation
import ObjectMapper

final class MeLiCategory: Mappable, Equatable {
    
    var id:   String?
    var name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
    
    static func == (lhs: MeLiCategory, rhs: MeLiCategory) -> Bool {
        return lhs.id == rhs.id
    }
}
