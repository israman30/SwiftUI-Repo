//
//  NetworkError.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case transport(URLError)
    case invalidResponse
    case httpStatus(code: Int)
    case decodingFailed(Error)
    case unknown(Error)
    
    var statusCode: Int? {
        guard case .httpStatus(let code) = self else {
            return nil
        }
        return code
    }
    
    var userMessage: String {
        switch self {
        case .transport(let urlError):
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internert connection. Verify your network."
            case .timedOut:
                return "Request time out. Please try again."
            default:
                return "Network error coccured. Please try again."
            }
        case .invalidResponse:
            return "Server return an invalid response."
        case .httpStatus(let code):
            switch code {
            case 401:
                return "No authroization granted. Please try again."
            case 403:
                return "You don't have permission to perform this action."
            case 404:
                return "Request not found."
            case 409:
                return "Comfict with existing data."
            case 429:
                return "Too many request. Try again later."
            case 500...599:
                return "Server is having troubles right now. Please try again later."
            default:
                return "Something went wrong. Try again later."
            }
        case .decodingFailed:
            return "Data received in an unexpected format."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
    
    var debugMessage: String {
        switch self {
        case .transport(let uRLError):
            return "Transport error: \(uRLError.code.rawValue) \(uRLError.localizedDescription)."
        case .invalidResponse:
            return "Invalid non-HTTP response."
        case .httpStatus(let code):
            return "HTTP \(code)."
        case .decodingFailed(let error):
            return "Decoding failed: \(error)."
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)."
        }
    }
    
    var errorDescription: String? {
        userMessage
    }
}
