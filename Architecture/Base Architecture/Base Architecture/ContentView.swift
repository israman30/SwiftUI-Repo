//
//  ContentView.swift
//  Base Architecture
//
//  Created by Israel Manzo on 10/1/25.
// https://jsonplaceholder.typicode.com/users

import SwiftUI
internal import Combine

struct User: Decodable {
    var id: Int
    var name: String
    var email: String
}

final class NetworkManager {
    func fetch() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

extension EnvironmentValues {
    @Entry var api = NetworkManager()
}

final class UserViewModel: ObservableObject {
    @Environment(\.api) private var api
    @Published var users: [User] = []
    @Published var loadingState: LoadingState = .loading
    
    enum LoadingState {
        case loading
        case success([User])
        case error(Error)
    }
    
    func load() async {
        do {
            users = try await api.fetch()
        } catch {
            loadingState = .error(error)
        }
    }
}

struct UserListView: View {
    let users: [User]
    var body: some View {
        if users.isEmpty {
            ContentUnavailableView("No user", image: "xmark.circle")
        } else {
            List(users, id: \.id) { user in
                Text(user.name)
            }
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        switch viewModel.loadingState {
        case .loading:
            ProgressView("Loading...")
                .task {
                    await viewModel.load()
                    viewModel.loadingState = .success(viewModel.users)
                }
        case .success(let users):
            UserListView(users: users)
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
