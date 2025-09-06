//
//  NetworkClient.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation

struct APIError: Error, Decodable {
    let message: String
}

struct NetworkClient {
 
    func signUp(name: String, email: String, password: String, avatar: URL) async throws -> SignupResponse {
        let signupRequest = SignupRequest(name: name, email: email, password: password, avatar: avatar)
        
        // Create request
        var request = URLRequest(url: Constants.Urls.signup)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(signupRequest)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30 // seconds
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        // Ensure valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Check status code range
        guard (200..<300).contains(httpResponse.statusCode) else {
            // Try to decode an error payload if available
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                throw apiError
            } else {
                throw URLError(.badServerResponse)
            }
        }
        // Decode response
        let decoded = try JSONDecoder().decode(SignupResponse.self, from: data)
        return decoded
    }
}
