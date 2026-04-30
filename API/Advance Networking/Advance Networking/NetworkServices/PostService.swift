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
    
    private let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    func fetchPost() async throws -> [Post] {
        let (data, response) = try await URLSession.shared.data(from: baseUrl)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    func post(_ payload: CreatedPost) async throws -> Post {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        
        let body = try JSONEncoder().encode(payload)
        request.httpBody = body
        request.setValue("application.json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Body Failed: \(httpResponse.statusCode) - \(bodyString)")
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Post.self, from: data)
    }
    
    func update(_ id: Int, payload: UpdatePost) async throws -> Post {
        let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "PUT"
        
        let body = try JSONEncoder().encode(payload)
        request.httpBody = body
        request.setValue("application.json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Body Failed: \(httpResponse.statusCode) - \(bodyString)")
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Post.self, from: data)
    }
    
    func delete(_ id: Int) async throws {
        
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
