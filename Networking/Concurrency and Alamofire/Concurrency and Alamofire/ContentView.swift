//
//  ContentView.swift
//  Concurrency and Alamofire
//
//  Created by Israel Manzo on 8/26/25.
//

import SwiftUI
import Alamofire

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let data = try Data(contentsOf: url)
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate()
                .responseDecodable(of: [User].self) { response in
                    switch response.result {
                    case .success(let users):
                        continuation.resume(returning: users)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    func loadUsers() {
        isLoading = true
        Task {
            do {
                let fetchedUsers = try await NetworkManager.shared.fetchUsers()
                users = fetchedUsers
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .onAppear {
                viewModel.loadUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}

// Simplify Reusable Continuation Pattern
//To avoid repetition, you can create a helper to wrap any Alamofire response in a Task
extension DataRequest {
    func serializingDecodable<T: Decodable>(_ type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// Now you can use it like this:
func fetchUsers() async throws -> [User] {
    let url = "https://jsonplaceholder.typicode.com/users"
    return try await AF.request(url).serializingDecodable([User].self)
}
