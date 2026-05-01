//
//  UserEndpointPath.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation


enum UserEndpointPath {
    case list
    case byId(Int)
    case emailAvailable
    
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
