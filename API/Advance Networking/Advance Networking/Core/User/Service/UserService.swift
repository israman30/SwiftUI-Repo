//
//  UserService.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUser() async throws -> [User]
    func create(_ payload: User) async throws -> User
    func update(_ id: Int, payload: UpdateUser) async throws -> User
}

struct UserService: UserServiceProtocol {
    /// API host: `https://jsonplaceholder.typicode.com`
    private let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/")!
    func fetchUser() async throws -> [User] {
        let requestModel = APIRequest<[User]>(method: .get, path: .users(.list))
        return try await execute(requestModel)
    }
    
    func create(_ payload: User) async throws -> User {
        let requestModel = try APIRequest<User>(method: .post, path: .users(.list), body: payload)
        return try await execute(requestModel)
    }
    
    func update(_ id: Int, payload: UpdateUser) async throws -> User {
        let requestModel = try APIRequest<User>(method: .put, path: .users(.byId(id)), body: payload)
        return try await execute(requestModel)
    }
    
    /// Executes an `APIRequest` and decodes the response into the requested type.
    ///
    /// Pipeline:
    /// - Build `URLRequest` from base URL + path/query/headers/body
    /// - Perform the request via `URLSession`
    /// - Validate HTTP status code (2xx success)
    /// - Decode JSON into `Response`
    private func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        let request = try requestModel.makeUrlRequest(baseURL: baseUrl)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            // For debugging: capture server-provided error payload if it’s UTF-8.
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Failed: \(httpResponse.statusCode) - \(bodyString)")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
}

class MockUserService {
    
}
