//
//  UserEndpointPath.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Relative paths for the Users endpoints.
///
/// These strings are appended to a base URL (for example `https://jsonplaceholder.typicode.com/`)
/// to build the final request URL.
enum UserEndpoint {
    /// Route: `GET /users` (also used for `POST /users` in this sample)
    case list
    /// Route: `/users/{id}` (used by this sample for `PUT`, and can also support `GET` by id)
    case byId(Int)
    /// Route: `GET /users/is-available`
    case emailAvailable
    
    /// Relative path string (no leading host, typically no leading `/`).
    var path: String {
        switch self {
        case .list:
            "users"
        case .byId(let id):
            "users/\(id)"
        case .emailAvailable:
            "users/is-available"
        }
    }
}
