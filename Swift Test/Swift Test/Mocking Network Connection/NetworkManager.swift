//
//  NetworkManager.swift
//  Swift Test
//
//  Created by Israel Manzo on 1/4/25.
//

import SwiftUI

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol Networking {
    func fetPosts() async throws -> [Post]
    func createPost(content: String) async throws -> Post
}

class NetworkManager: Networking {
    let urlSession: URLSession
    let baseUrl: URL = URL(string: "https://jsonplaceholder.typicode.com/")!
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func fetPosts() async throws -> [Post] {
        let url = baseUrl.appending(path: "posts")
        let (data, _ ) = try await urlSession.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    func createPost(content: String) async throws -> Post {
        let url = baseUrl.appending(path: "posts")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["contents":content]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(Post.self, from: data)
    }
}
