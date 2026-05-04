//
//  NetworkServices.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

struct NetworkServices {
    /// Builds a request with an `Authorization: Bearer ...` header.
    ///
    /// This refreshes the token *opportunistically* if it's near expiry, so callers
    /// don't have to remember to do it before every API call.
    private func authorizedRequest(for url: URL) async throws -> URLRequest {
        try await TokenManager.shared.refreshTokenIfNeeded()

        guard TokenManager.shared.isAuthenticated,
              let bearer = TokenManager.shared.bearerHeader else {
            throw AuthError.tokenExpired
        }

        var request = URLRequest(url: url)
        request.setValue(
            bearer,
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
        let request = try await authorizedRequest(for: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        // ... rest of implementation
    }
}
