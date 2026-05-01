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
    
    private let client: APIClient
    
    init() {
        self.client = APIClient(baseUrl: baseUrl)
    }
    
    func fetchUser() async throws -> [User] {
        let requestModel = APIRequest<[User]>(method: .get, path: .users(.list))
        return try await client.execute(requestModel)
    }
    
    func create(_ payload: User) async throws -> User {
        let requestModel = try APIRequest<User>(method: .post, path: .users(.list), body: payload)
        return try await client.execute(requestModel)
    }
    
    func update(_ id: Int, payload: UpdateUser) async throws -> User {
        let requestModel = try APIRequest<User>(method: .put, path: .users(.byId(id)), body: payload)
        return try await client.execute(requestModel)
    }
    
}

class MockUserService {
    
}
