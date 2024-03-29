//
//  AppError.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 19/03/2024.
//

import Foundation

final class AppError: NSObject, LocalizedError {
    let message: String
    
    init(_ message: String) {
        self.message = message
        super.init()
    }
    
    override var description: String {
        return message
    }
    
    var errorDescription: String? {
        return message
    }
    
    static let connectionError   = AppError("Hubo un error con tu conexión de internet, por favor intenta nuevamente")
    
    static let unhandled         = AppError("Unknown error")
    static let emptyResponse     = AppError("Empty response")
    static let parsingError      = AppError("Parsing error")
    static let invalidStatusCode = AppError("Invalid Status Code")
}

final class DDUnhandledNetworkingError: NSObject, LocalizedError {
    let json: [String: Any?]
    
    init(_ json: [String: Any?]) {
        self.json = json
        super.init()
    }
    
    override var description: String {
        return ""
//        return message
    }
    
    var errorDescription: String? {
        return ""
//        return message
    }
}

