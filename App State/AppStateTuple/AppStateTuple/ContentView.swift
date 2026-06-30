//
//  ContentView.swift
//  AppStateTuple
//
//  Created by Israel Manzo on 6/30/26.
//

import SwiftUI
import Combine

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

@MainActor
class UserViewModel: ObservableObject {
    @Published var appState: AppState = .empty
    private let network: NetworkManager
    @Published var posts = [Post]()
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func loadData() async {
        appState = .loading
        
        do {
            posts = try await network.fetchData()
            appState = .loaded
        } catch {
            appState = .error(error)
        }
    }
}

struct ContentView: View {
    @StateObject var vm: UserViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: .init(network: .init()))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                switch vm.appState {
                case .loading:
                    ProgressView()
                    Text("Loading posts...")
                case .empty:
                    Text("No posts available.")
                case .error(let error):
                    Text("Error: \(error.localizedDescription)")
                case .loaded:
                    List(vm.posts, id: \.id) { post in
                        Text(post.title)
                    }
                }
            }
            .task {
                await vm.loadData()
            }
        }
    }
}

#Preview {
    ContentView()
}
