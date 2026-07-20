//
//  NetworkLayer.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/19/26.
//

import Foundation

// https://jsonplaceholder.typicode.com/users

struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

enum APIError: Error {
    case errorResponse
}

class NetworkLayer {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        return try JSONDecoder().decode([User].self, from: data)
    }
}

