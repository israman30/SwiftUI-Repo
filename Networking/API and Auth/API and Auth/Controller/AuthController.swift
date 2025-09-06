//
//  AuthController.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation

struct AuthController {
    
    let networkClient: NetworkClient
    
    func signUp(name: String, email: String, password: String) async throws -> SignupResponse {
        let response = try await networkClient.signUp(name: name, email: email, password: password, avatar: URL(string: "https://picsum.photos/800")!)
        return response
    }
    
    func login(with email: String, password: String) async throws -> Bool {
        let response = try await networkClient.login(with: email, password: password)
        
        // save access toke in keychain
        Keychain.set(response.accessToken, forKey: "accessToken")
        Keychain.set(response.refreshToken, forKey: "refreshToken")
        
        return false
    }
}
