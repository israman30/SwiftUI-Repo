//
//  Routes.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Centralized constants for the API layer.
///
/// Keep values that are shared across services here (base URL, common header keys, etc.) to avoid
/// duplicating strings and to make future changes safer (single source of truth).
enum APIConstants {
    /// Base API host used by the sample services.
    ///
    /// API host: `https://jsonplaceholder.typicode.com`
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com/")!
    
    /// Common HTTP header field keys.
    enum HeaderField {
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let authorization = "Authorization"
    }
    
    /// Common header values.
    enum HeaderValue {
        static let json = "application/json"
    }
}

/// Top-level typed routes for the API.
///
/// Each case represents a route group (e.g. posts, users, comments). The resolved `path` is a
/// relative URL path (no scheme/host) used by `APIRequest.makeUrlRequest(baseURL:)`.
enum APIRoutes {
    /// Posts feature routes.
    case post(PostEndpoint)
    /// Users feature routes.
    case users(UserEndpoint)
    
    /// Resolved relative URL path for the selected route.
    var path: String {
        switch self {
        case .post(let endpoint):
            endpoint.path
        case .users(let endpoint):
            endpoint.path
        }
    }
}
