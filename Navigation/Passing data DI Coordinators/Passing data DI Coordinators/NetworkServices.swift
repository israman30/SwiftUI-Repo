//
//  NetworkServices.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/20/24.
//

import SwiftUI

enum APIError: Error {
    case errorResponse
}

//https://jsonplaceholder.typicode.com/users

struct NetworkServices {
    
    func fetchData() async throws -> [Users] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        return try JSONDecoder().decode([Users].self, from: data)
    }
}
