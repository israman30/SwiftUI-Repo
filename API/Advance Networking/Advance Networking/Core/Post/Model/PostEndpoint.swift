//
//  EndpointPath.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Relative paths for the Posts endpoints.
///
/// These strings are appended to a base URL (for example `https://jsonplaceholder.typicode.com/`)
/// to build the final request URL.
enum PostEndpoint {
    /// Route: `GET /posts` (also used for `POST /posts`)
    case list
    /// Route: `GET/PUT/DELETE /posts/{id}`
    case byId(Int)
    
    /// Relative path string (no leading host, typically no leading `/`).
    var path: String {
        switch self {
        case .list:
            "posts"
        case .byId(let id):
            "posts/\(id)"
        }
    }
}
