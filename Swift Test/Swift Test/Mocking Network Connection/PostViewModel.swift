//
//  PostViewModel.swift
//  Swift Test
//
//  Created by Israel Manzo on 1/4/25.
//

import SwiftUI
import Observation

enum PostState {
    case loaded(_ posts: [Post])
    case loading
    case noLoaded
    case error(_ error: Error)
}

@Observable
class PostViewModel {
    var postState: PostState = .noLoaded
    private let networkService: Networking
    
    init(networkService: Networking) {
        self.networkService = networkService
    }
    
    func fetchPost() async {
        postState = .loading
        do {
            let posts = try await networkService.fetPosts()
            postState = .loaded(posts)
        } catch {
            postState = .error(error)
        }
    }
    
    func createPost(content: String) async throws -> Post {
        return try await networkService.createPost(content: content)
    }
}
