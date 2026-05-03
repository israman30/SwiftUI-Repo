//
//  NetworkServices.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct PaginationResponse<T: Decodable>: Decodable {
    let item: [T]
    let total: Int
    let limit: Int
    let offset: Int
    
    var hasMore: Bool {
        offset + limit < total
    }
}

protocol NetworkServicesProtocol {
    func fetchUser(_ limit: Int, offset: Int) async throws -> PaginationResponse<User>
}

final class NetworkServices: NetworkServicesProtocol {
    
    func fetchUser(_ limit: Int, offset: Int) async throws -> PaginationResponse<User> {
        var components = URLComponents(string: Constants.endopint.appending("/users"))
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        // Log Request
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Log Response
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                throw URLError(.badURL)
            }
            
            let paginated = try JSONDecoder().decode(PaginationResponse<User>.self, from: data)
            
            // Log Result
            return paginated
        } catch {
            // Log error
            throw error
        }
    }
}
