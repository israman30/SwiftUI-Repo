//
//  ContentView.swift
//  Pagination Implementatoin
//
//  Created by Israel Manzo on 5/1/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/users

struct Constants {
    static let endpoint = "https://jsonplaceholder.typicode.com"
}

enum APIError: Error {
    case errorResponse
}

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

class NetworkManager {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: Constants.endpoint.appending("/users"))
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
    private let service: NetworkManager
    
    init(_ service: NetworkManager) {
        self.service = service
    }
    
    func load() async {
        do {
            self.users = try await service.fetchUsers()
        } catch {
            print("Somethign went wrong: \(error)")
        }
    }
    
}

struct ContentView: View {
    @StateObject var vm = ViewModel(NetworkManager())
    var body: some View {
        NavigationView {
            List(vm.users) { user in
                Text(user.name)
            }
            .task {
                await vm.load()
            }
            .navigationTitle("Pagination")
        }
    }
}

#Preview {
    ContentView()
}
