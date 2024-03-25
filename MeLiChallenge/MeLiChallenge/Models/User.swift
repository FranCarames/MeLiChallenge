//
//  User.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 19/03/2024.
//

import Foundation

final class User: NSObject, Decodable {
    
    var id: String?
    var name: String?
    var username: String?
    var birthday: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username_profile"
        case birthday = "birthday_st"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        birthday = try container.decodeIfPresent(String.self, forKey: .birthday)
    }
}
