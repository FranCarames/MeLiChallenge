//
//  Dictionary+ClearNulls.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation

extension Dictionary where Key == String, Value == Any? {
    func cleanNulls() -> [String : Any] {
        var cleanDict = [String : Any]()

        for entry in self {
            if let value = entry.value {
                cleanDict[entry.key] = value
            }
        }

        return cleanDict
    }
}
