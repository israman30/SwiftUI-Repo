//
//  NetworkError.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

/// Domain error type for the networking layer.
///
/// This enum separates common failure categories so higher layers can decide how to react:
/// - show a friendly UI message (`errorDescription` / `userMessage`)
/// - log developer-focused details (`debugMessage`)
/// - optionally branch on HTTP status (`statusCode`)
///
/// Conforms to `LocalizedError` so SwiftUI alerts and other UI surfaces can display
/// `errorDescription` directly.
enum NetworkError: Error, LocalizedError {
    /// A transport-level failure from `URLSession` before an HTTP response was produced
    /// (offline, timeout, DNS failure, etc.).
    case transport(URLError)
    /// The request completed but the response wasn't an `HTTPURLResponse`.
    case invalidResponse
    /// The server returned a non-2xx HTTP status code.
    case httpStatus(code: Int)
    /// The server returned data, but decoding into the expected model failed.
    case decodingFailed(Error)
    /// A catch-all for unexpected errors that don't fit the other categories.
    case unknown(Error)
    
    /// Extracts an HTTP status code when the error is `.httpStatus`.
    var statusCode: Int? {
        guard case .httpStatus(let code) = self else {
            return nil
        }
        return code
    }
    
    /// User-facing message intended for UI surfaces (alerts, toasts, inline errors).
    ///
    /// This intentionally hides low-level details and focuses on actionable guidance.
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
    
    /// Developer-facing message intended for logs/analytics.
    ///
    /// This is useful during debugging because it preserves the underlying error and context.
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
    
    /// `LocalizedError` hook used by many UI presentation APIs.
    var errorDescription: String? {
        userMessage
    }
}

enum NetworkErrorMapper {
    static func map(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        if let urlError = error as? URLError {
            return .transport(urlError)
        }
        return .unknown(error)
    }
    
    static func httpStatu(_ code: Int) -> NetworkError {
        .httpStatus(code: code)
    }
    
    static func decodeFailure(_ error: Error) -> NetworkError {
        .decodingFailed(error)
    }
}
