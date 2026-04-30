//
//  PostService.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

protocol PostServiceProtocol {
    func fetchPost() async throws -> [Post]
}

class ProductNetwork: PostServiceProtocol {
    static var shared = ProductNetwork()
    
    private let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    func fetchPost() async throws -> [Post] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

class MockProductNetwork: PostServiceProtocol {
    func fetchPost() async throws -> [Post] {
        return [
            Post(userId: 1, id: 1, title: "This a mock post", body: "This is a body for the first post"),
            Post(userId: 2, id: 2, title: "This another mock post", body: "This is a body for the second post")
        ]
    }
}
