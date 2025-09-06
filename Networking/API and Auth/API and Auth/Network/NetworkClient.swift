//
//  NetworkClient.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation

struct NetworkClient {
 
    func signUp(name: String, email: String, password: String, avatar: URL) async throws -> SignupResponse {
        let signupRequest = SignupRequest(name: name, email: email, password: password, avatar: avatar)
        var request = URLRequest(url: Constants.Urls.signup)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(signupRequest)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _ ) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SignupResponse.self, from: data)
        return response
    }
}
