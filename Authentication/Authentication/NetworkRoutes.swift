//
//  NetworkRoutes.swift
//  Authentication
//
//  Created by Israel Manzo on 3/29/24.
//

import Foundation

enum NetworkRoutes {
    
    private static let baseUrl = "http://127.0.0.1:8080/"
    
    case signup
    case accessToken
    case loginData
    
    var url: URL? {
        var path: String
        switch self {
        case .signup:
            path = NetworkRoutes.baseUrl + "api/signup/"
        case .accessToken:
            path = NetworkRoutes.baseUrl + "api/auth/token/"
        case .loginData:
            path = NetworkRoutes.baseUrl + "api/login_data/"
        }
        return URL(string: path)
    }
    
    var method: HTTPMethod {
        switch self {
        case .signup, .accessToken:
            return .post
        case .loginData:
            return .get
        }
    }
}
