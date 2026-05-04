//
//  NetworkServices.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

struct NetworkServices {
    private func authorizedRequest(for url: URL) throws -> URLRequest {
        // Auto-refresh token if near expiry
        guard TokenManager.shared.isAuthenticated else {
            throw AuthError.tokenExpired
        }

        var request = URLRequest(url: url)
        request.setValue(
            TokenManager.shared.bearerHeader,
            forHTTPHeaderField: "Authorization"
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func fetchUsers(limit: Int = 10, offset: Int = 0) async throws {
        var components = URLComponents(string: Constants.endpoint.appending("/users"))
        components?.queryItems = [
            URLQueryItem(name: "limit",  value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        // ── Authorized request with Bearer token
        let request = try authorizedRequest(for: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        // ... rest of implementation
    }
}
