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
        // Keeping token access local makes the demo lightweight.
        // In a larger app, prefer injecting a token provider (or URLSession/transport) for testability.
        guard let token = UserDefaults.standard.string(forKey: AuthStore.tokenDefaultsKey),
              !token.isEmpty else {
            throw APIError.unauthorized
        }
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        return try JSONDecoder().decode([User].self, from: data)
    }
}
