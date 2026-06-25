//
//  ContentView.swift
//  AppStateResult
//
//  Created by Israel Manzo on 6/25/26.
// https://jsonplaceholder.typicode.com/posts
/**
 "userId": 1,
 "id": 1,
 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 "body":
 */

import SwiftUI
import Combine

struct User: Decodable {
    let id: Int
    let title: String
    let body: String
}

class NetworkManager {
    func fetchData() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _ ) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

enum AppState<Value> {
    case idle
    case loading
    case loaded(Result<Value, Error>)
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var appState: AppState<[User]> = .idle
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func loadUsers() async {
        appState = .loading
        do {
            let users = try await network.fetchData()
            appState = .loaded(.success(users))
        } catch {
            appState = .loaded(.failure(error))
        }
    }
}



struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
