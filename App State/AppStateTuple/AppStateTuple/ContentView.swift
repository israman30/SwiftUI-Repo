//
//  ContentView.swift
//  AppStateTuple
//
//  Created by Israel Manzo on 6/30/26.
//

import SwiftUI

enum AppState: Equatable {
    case loading
    case empty
    case loaded
    case error(Error)
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.empty, .empty):
            return true
        case (.loaded, .loaded):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

extension AppState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }
    
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    var error: Error? {
        if case .error(let error) = self { return error }
        return nil
    }
}

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

class NetworkManager {
    func fetchData() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _ ) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

@Observable
@MainActor
class PostViewModel {
    var state: AppState = .empty
    var posts: [Post] = []
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchPosts() async {
        state = .loading
        do {
            posts = try await network.fetchData()
            
            if posts.isEmpty {
                state = .empty
                return
            } else {
                state = .loaded
            }
            
        } catch {
            state = .error(error)
        }
    }
    
}

struct ContentView: View {
    @State var vm = PostViewModel(network: .init())
    var body: some View {
        ScrollView {
            LazyVStack {
                switch vm.state {
                case .loading:
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loasing...")
                    }
                case .empty:
                    VStack {
                        Image(systemName: "book.closed")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No verses found")
                            .font(.headline)
                        Text("Try a different book or chapter")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                case .loaded:
                    List(vm.posts, id: \.id) { post in
                        Text(post.title)
                    }
                case .error(let error):
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundStyle(.red)
                        VStack(spacing: 8) {
                            Text("Something went wrong")
                                .font(.headline)
                            Text(error.localizedDescription)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        Button("Retry") {
                            Task {
                                await vm.fetchPosts()
                            }
                        }
                    }
                }
            }
            .task {
                await vm.fetchPosts()
            }
        }
    }
}

#Preview {
    ContentView()
}
