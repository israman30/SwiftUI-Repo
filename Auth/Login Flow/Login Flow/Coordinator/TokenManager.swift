//
//  TokenManager.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "login_flow.auth.token"
    
    private init() {}
    
    var token: String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }
    
    var isAuthenticated: Bool {
        token != nil
    }
    
    func storeToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}

