//
//  NetworkServices.swift
//  Networking with async
//
//  Created by Israel Manzo on 1/11/23.
//

import SwiftUI

enum APIError: Error {
    case errorResponse
}

protocol NetworkServices {
    func fetchUsers() async throws -> [User]
}

final class NetworkServicesImplementation: NetworkServices {
    
    func fetchUsers() async throws -> [User] {
        let url = URL(string: Constants.endopint.appending("/users"))
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
                
        return try JSONDecoder().decode([User].self, from: data)
    }
}
