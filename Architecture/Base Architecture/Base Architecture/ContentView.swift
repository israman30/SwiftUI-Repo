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
    
    func load() async {
        do {
            users = try await api.fetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        List(viewModel.users, id: \.id) { user in
            Text(user.name)
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
