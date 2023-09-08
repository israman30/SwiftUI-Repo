//
//  CoinAPIError.swift
//  Mastering Networking
//
//  Created by Israel Manzo on 9/7/23.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsinFailure
    case requesFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var description: String {
        switch self {
        case .invalidData: return "Invalis Data"
        case .jsonParsinFailure: return "Failed parse JSON"
        case let .requesFailed(description): return "Request failed \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid status code \(statusCode)"
        case let .unknownError(error): return "Unknown error occured \(error.localizedDescription)"
        }
    }
}
