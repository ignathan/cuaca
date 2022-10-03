//
//  ErrorResponse.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

import Foundation

struct ErrorResponse: Codable {
    
    struct APIError: LocalizedError, Codable {
        let code: Int
        let message: String
        
        var errorDescription: String? {
            return String(format: "%d: %@", code, message)
        }
    }
    let error: APIError
}
