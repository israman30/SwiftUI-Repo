import UIKit
import SwiftUI

/**
 `Architecture Overview
 `- NetworkService → Handles HTTP calls
 `- Repository → Bridges network & business logic
 `- ViewModel → Owns state & async logic (with @Observable)
 `- View → Binds to ViewModel for rendering
 */

// MARK: - MODEL
struct User: Decodable {
    let name: String
}

/**
 ` NetworkManager
 Let’s start with a reusable, shared service that performs API calls.
 */
final class NetworkManager {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

/**
`MARK: Step 2: Repository Pattern
Now abstract the networking logic in a repository so your ViewModel doesn’t talk directly to URLSession
 */
protocol UserRepositoryProtocol {
    func fetchUsers() async throws -> [User]
}

final class UserRepository: UserRepositoryProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchUsers() async throws -> [User] {
        try await self.networkManager.fetchUsers()
    }
}

// MARK: - VIEW MODEL
@Observable
@MainActor
class UserViewModel {
    var users: [User] = []
    var isLoading = false
    var errorMessage: String? = nil
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func render() async {
        isLoading = true
        errorMessage = nil
        users.removeAll()
        
        do {
            users = try await repository.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

/**
 `Step 4: SwiftUI View Binding to ViewModel
  Now let’s build the view and bind it to the ViewModel’s state.
 */
struct UserListView: View {
    @State var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            } else {
                List(viewModel.users, id: \.name) { user in
                    Text(user.name)
                }
            }
        }
        .task {
            await viewModel.render()
        }
    }
}
