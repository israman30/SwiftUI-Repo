//
//  PostListView.swift
//  App State (loading data)
//
//  Created by Israel Manzo on 6/4/26.
// https://jsonplaceholder.typicode.com/posts

import SwiftUI
import Observation

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

class NetworkLayer {
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

@MainActor
@Observable
class PostViewModel {
    var loadingState: LoadingState<[Post]> = .empty
    private let networkLayer = NetworkLayer()
    
    func fetchPosts() async {
        loadingState = .loading
        
        do {
            let posts = try await networkLayer.fetchPosts()
            loadingState = posts.isEmpty ? .empty : .loaded(posts)
        } catch {
            loadingState = .error(error)
        }
    }
}

struct PostListView: View {
    @State private var viewModel = PostViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
                Text("Loading posts...")
            case .empty:
                Text("No posts available.")
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            case .loaded(let posts):
                List(posts, id: \.id) { post in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchPosts()
        }
    }
}

#Preview {
    PostListView()
}
