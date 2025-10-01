//
//  ContentView.swift
//  Base Architecture
//
//  Created by Israel Manzo on 10/1/25.
// https://jsonplaceholder.typicode.com/users

import SwiftUI

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
