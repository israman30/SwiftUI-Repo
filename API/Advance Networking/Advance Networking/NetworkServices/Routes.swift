//
//  Routes.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Top-level typed routes for the API.
///
/// Each case represents a route group (e.g. posts, users, comments). The resolved `path` is a
/// relative URL path (no scheme/host) used by `APIRequest.makeUrlRequest(baseURL:)`.
enum APIRoutes {
    /// Posts feature routes.
    case post(EndpointPath)
    
    /// Resolved relative URL path for the selected route.
    var path: String {
        switch self {
        case .post(let endpointPath):
            endpointPath.path
        }
    }
}
