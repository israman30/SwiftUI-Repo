//
//  NetworkServices.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

/// A normalized pagination envelope used by the app regardless of how the backend formats responses.
///
/// Note: JSONPlaceholder returns a raw array for `/users` (not an envelope). We adapt it into this shape
/// so the view model can remain consistent.
struct PaginationResponse<T> {
    /// Items returned for this "page".
    let item: [T]
    /// Total number of items available. Some APIs provide this via headers; others don't provide it at all.
    let total: Int
    /// Page size used for the request.
    let limit: Int
    /// Offset used for the request.
    let offset: Int

    /// Indicates whether requesting the next page should return more items.
    var hasMore: Bool { offset + limit < total }
}

protocol NetworkServicesProtocol {
    func fetchUser(limit: Int, offset: Int) async throws -> PaginationResponse<User>
}

/// Fetches paginated users from JSONPlaceholder.
///
/// JSONPlaceholder supports pagination using:
/// - `_limit`: number of items
/// - `_start`: offset
///
/// The endpoint returns `[User]` and may include `x-total-count` for some resources.
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

        // `URLSession` throws for transport-level failures. HTTP errors still come back as responses,
        // so we validate the status code explicitly.
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // `/users` returns a raw array, not an envelope object.
        let users = try JSONDecoder().decode([User].self, from: data)

        // Prefer a server-provided total count when available.
        let headerTotal = http.value(forHTTPHeaderField: "x-total-count").flatMap(Int.init)
        // Fallback: estimate "total" just enough to drive `hasMore` correctly without a true total.
        // - if we received a full page, assume there may be more
        // - if we received fewer than `limit`, assume this was the last page
        let fallbackTotal = offset + users.count + (users.count == limit ? 1 : 0)

        return PaginationResponse(
            item: users,
            total: headerTotal ?? fallbackTotal,
            limit: limit,
            offset: offset
        )
    }
}
