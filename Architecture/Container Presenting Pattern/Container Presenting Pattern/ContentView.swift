//
//  ContentView.swift
//  Container Presenting Pattern
//
//  Created by Israel Manzo on 9/12/25.
//
// source: https://www.patterns.dev/react/presentational-container-pattern/
// https://jsonplaceholder.typicode.com/users

import SwiftUI

struct ContentView: View {
    var body: some View {
        UserListScreen()
    }
}

#Preview {
    ContentView()
}

// Model
struct User: Codable, Identifiable {
    let id: Int
    let name: String
}

// Network
struct NetworkClient {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

extension EnvironmentValues {
    @Entry var networkClient: NetworkClient = .init()
}

// Presenter
struct UserListView: View {
    let users: [User]
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
    }
}

// Container
struct UserListScreen: View {
    
    @Environment(\.networkClient) private var networkClient
    @State private var users: [User] = []
    
    var body: some View {
        VStack {
            UserListView(users: users)
                .task {
                    do {
                        users = try await networkClient.fetchUsers()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
    }
}
