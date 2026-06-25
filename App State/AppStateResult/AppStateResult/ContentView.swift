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
    @StateObject var viewModel: UserViewModel
    
    init() {
        self._viewModel = .init(wrappedValue: .init(network: .init()))
    }
    var body: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.appState {
                case .idle:
                    Text("ide")
                case .loading:
                    Text("Lading..")
                case .loaded(let result):
                    switch result {
                    case .success(let users):
                        ForEach(users, id: \.id) { user in
                            VStack(alignment: .leading) {
                                Text(user.title)
                                    .font(.title)
                                Text(user.body)
                            }
                            .padding()
                        }
                    case .failure(let error):
                        Text("Error: \(error.localizedDescription)")
                    }
                }
            }
            .task {
                await viewModel.loadUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}
