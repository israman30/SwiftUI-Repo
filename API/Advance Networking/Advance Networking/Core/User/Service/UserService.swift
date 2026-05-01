//
//  UserService.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Abstraction for the "Users" remote data source.
///
/// Protocol-based design keeps the view model testable by allowing mocks to be injected.
protocol UserServiceProtocol {
    /// Route: `GET /users`
    func fetchUser() async throws -> [User]
    /// Route: `POST /users`
    func create(_ payload: User) async throws -> User
    /// Route: `PUT /users/{id}`
    func update(_ id: Int, payload: UpdateUser) async throws -> User
}

/// Concrete network-backed implementation of `UserServiceProtocol`.
///
/// Builds typed requests (`APIRequest`) and delegates execution/decoding to `APIClient`.
struct UserService: UserServiceProtocol {
    
    private let client: APIClient
    
    init() {
        self.client = APIClient(baseUrl: APIConstants.baseURL)
    }
    
    func fetchUser() async throws -> [User] {
        // Route: `GET /users`
        let requestModel = APIRequest<[User]>(method: .get, path: .users(.list))
        return try await client.execute(requestModel)
    }
    
    func create(_ payload: User) async throws -> User {
        // Route: `POST /users`
        let requestModel = try APIRequest<User>(method: .post, path: .users(.list), body: payload)
        return try await client.execute(requestModel)
    }
    
    func update(_ id: Int, payload: UpdateUser) async throws -> User {
        // Route: `PUT /users/{id}`
        let requestModel = try APIRequest<User>(method: .put, path: .users(.byId(id)), body: payload)
        return try await client.execute(requestModel)
    }
    
}

class MockUserService {
    
}
