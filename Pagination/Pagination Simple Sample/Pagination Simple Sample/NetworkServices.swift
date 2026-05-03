//
//  NetworkServices.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct PaginationResponse<T> {
    let item: [T]
    let total: Int
    let limit: Int
    let offset: Int

    var hasMore: Bool { offset + limit < total }
}

protocol NetworkServicesProtocol {
    func fetchUser(limit: Int, offset: Int) async throws -> PaginationResponse<User>
}

final class NetworkServices: NetworkServicesProtocol {
    
    func fetchUser(limit: Int = 10, offset: Int) async throws -> PaginationResponse<User> {
        var components = URLComponents(string: Constants.endopint.appending("/users"))
        components?.queryItems = [
            // JSONPlaceholder uses `_limit` and `_start` for pagination.
            URLQueryItem(name: "_limit", value: "\(limit)"),
            URLQueryItem(name: "_start", value: "\(offset)")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // `/users` returns a raw array, not an envelope object.
        let users = try JSONDecoder().decode([User].self, from: data)

        let headerTotal = http.value(forHTTPHeaderField: "x-total-count").flatMap(Int.init)
        let fallbackTotal = offset + users.count + (users.count == limit ? 1 : 0)

        return PaginationResponse(
            item: users,
            total: headerTotal ?? fallbackTotal,
            limit: limit,
            offset: offset
        )
    }
}
