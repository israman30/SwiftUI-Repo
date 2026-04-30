//
//  MyViewModel.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

@MainActor
class MyViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var service: PostServiceProtocol
    
    init(service: PostServiceProtocol) {
        self.service = service
    }
    
    func fetchPost() async {
        do {
            self.posts = try await service.fetchPost()
        } catch {
            print("DEBUG: something went wrong: \(error)")
        }
    }
}

protocol PostServiceProtocol {
    func fetchPost() async throws -> [Post]
}

class ProductNetwork: PostServiceProtocol {
    static var shared = ProductNetwork()
    func fetchPost() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

class MockProductNetwork: PostServiceProtocol {
    func fetchPost() async throws -> [Post] {
        return []
    }
}
