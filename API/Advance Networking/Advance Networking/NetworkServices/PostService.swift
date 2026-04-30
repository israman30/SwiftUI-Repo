//
//  PostService.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

protocol PostServiceProtocol {
    func fetchPost() async throws -> [Post]
    func post(_ payload: CreatedPost) async throws -> Post
    func update(_ id: Int, payload: UpdatePost) async throws -> Post
    func delete(_ id: Int) async throws
}

class ProductNetwork: PostServiceProtocol {
    static var shared = ProductNetwork()
    
    private let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/")!
    
    func fetchPost() async throws -> [Post] {
        let requestModel = APIRequest<[Post]>(method: .get, path: "posts")
        return try await execute(requestModel)
    }
    
    func post(_ payload: CreatedPost) async throws -> Post {
        let requestModel = try APIRequest<Post>(method: .post, path: "posts", body: payload)
        return try await execute(requestModel)
    }
    
    func update(_ id: Int, payload: UpdatePost) async throws -> Post {
        let requestModel = try APIRequest<Post>(method: .put, path: "posts/\(id)", body: payload)
        return try await execute(requestModel)
    }
    
    func delete(_ id: Int) async throws {
        let requestModel = APIRequest<EmptyRespons>(method: .delete, path: "posts/\(id)")
        let _ = try await execute(requestModel)
    }
    
    private func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        let request = try requestModel.makeUrlRequest(baseURL: baseUrl)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Failed: \(httpResponse.statusCode) - \(bodyString)")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

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
