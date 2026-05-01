//
//  PostService.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

/// Abstraction for the "Posts" remote data source.
///
/// The protocol makes the view model testable by allowing a mock implementation to be injected.
protocol PostServiceProtocol {
    func fetchPost() async throws -> [Post]
    func post(_ payload: CreatedPost) async throws -> Post
    func update(_ id: Int, payload: UpdatePost) async throws -> Post
    func delete(_ id: Int) async throws
}

/// Concrete network-backed implementation of `PostServiceProtocol`.
///
/// This sample uses `jsonplaceholder.typicode.com` to demonstrate GET/POST/PUT/DELETE patterns
/// with a small request model (`APIRequest`) and a single execution pipeline (`execute`).
class ProductNetwork: PostServiceProtocol {
    static var shared = ProductNetwork()
    
    /// Base URL for all requests in this service.
    ///
    /// API host: `https://jsonplaceholder.typicode.com`
    private let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/")!
    
    private let client: APIClient
    
    init() {
        self.client = APIClient(baseUrl: baseUrl)
    }
    
    /// Fetches all posts.
    ///
    /// Route: `GET /posts`
    func fetchPost() async throws -> [Post] {
        let requestModel = APIRequest<[Post]>(method: .get, path: .post(.list))
        return try await client.execute(requestModel)
    }
    
    /// Creates a new post (JSON body + `Content-Type: application/json`).
    ///
    /// Route: `POST /posts`
    func post(_ payload: CreatedPost) async throws -> Post {
        let requestModel = try APIRequest<Post>(method: .post, path: .post(.list), body: payload)
        return try await client.execute(requestModel)
    }
    
    /// Updates an existing post by id.
    ///
    /// Route: `PUT /posts/{id}`
    func update(_ id: Int, payload: UpdatePost) async throws -> Post {
        let requestModel = try APIRequest<Post>(method: .put, path: .post(.byId(id)), body: payload)
        return try await client.execute(requestModel)
    }
    
    /// Deletes an existing post by id.
    ///
    /// Route: `DELETE /posts/{id}`
    func delete(_ id: Int) async throws {
        let requestModel = APIRequest<EmptyRespons>(method: .delete, path: .post(.byId(id)))
        let _ = try await client.execute(requestModel)
    }
}

/// In-memory fake implementation used for previews/tests without hitting the network.
class MockProductNetwork: PostServiceProtocol {
    func fetchPost() async throws -> [Post] {
        return [
            Post(userId: 1, id: 1, title: "This a mock post", body: "This is a body for the first post"),
            Post(userId: 2, id: 2, title: "This another mock post", body: "This is a body for the second post")
        ]
    }
    
    func post(_ payload: CreatedPost) async throws -> Post {
        Post(userId: 3, id: 3, title: "Post", body: "Post body")
    }
    
    func update(_ id: Int, payload: UpdatePost) async throws -> Post {
        Post(userId: 3, id: 3, title: "Post", body: "Post body")
    }
    
    func delete(_ id: Int) async throws {
        
    }
}
