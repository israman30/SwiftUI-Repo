//
//  ContentView.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI
import Combine

enum APIError: Error {
    case errorResponse
}

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}
// https://jsonplaceholder.typicode.com/users
struct NetworkManager {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        return try JSONDecoder().decode([User].self, from: data)
    }
}

class ViewModel: ObservableObject {
    @Published var users = [User]()
    
    private var services: NetworkManager
    
    init(services: NetworkManager) {
        self.services = services
    }
    
    func loadUsers() async {
        do {
            self.users = try await services.fetchUsers()
        } catch {
            print("Something went wrong: \(error)")
        }
    }
}

struct ContentView: View {
    @StateObject var vm = ViewModel(services: NetworkManager())
    var body: some View {
        VStack {
            List(vm.users) { user in
                Text(user.name)
            }
            .task {
                await vm.loadUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}
