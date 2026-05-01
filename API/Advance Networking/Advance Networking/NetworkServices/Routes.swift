//
//  Routes.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

struct URLConstants {
    static let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/")!
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
