//
//  NetworkManager.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

enum APIError: Error {
    case errorResponse
    case unauthorized
    case invalidToken
}

// https://jsonplaceholder.typicode.com/users
struct NetworkManager {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await authorizedData(for: request, retryOnUnauthorized: true)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        return try JSONDecoder().decode([User].self, from: data)
    }
    
    private func authorizedData(for request: URLRequest, retryOnUnauthorized: Bool) async throws -> (Data, URLResponse) {
        var request = request
        let token = try await TokenManager.shared.validAccessToken(minValidity: 60)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let http = response as? HTTPURLResponse,
           http.statusCode == 401,
           retryOnUnauthorized {
            _ = try await TokenManager.shared.refresh()
            return try await authorizedData(for: request, retryOnUnauthorized: false)
        }
        
        return (data, response)
    }
}
