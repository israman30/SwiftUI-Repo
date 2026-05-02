//
//  UserViewModel.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

@MainActor
/// UI-facing state + intent handlers for the Users feature.
///
/// `loadingState` is the single source of truth for the screen rendering:
/// - set to `.loading` when a request starts
/// - set to `.loaded([User])` / `.empty` on success
/// - set to `.error(message)` on failure
class UserViewModel: ObservableObject {
    
    /// Publishes screen state so SwiftUI can re-render automatically.
    @Published var loadingState: LoadingState<[User]> = .idle
    
    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    /// Loads users and updates `loadingState` for the view to render.
    func loadUsers() async {
        loadingState = .loading
        do {
            let users = try await service.fetchUser()
            loadingState = users.isEmpty ? .empty : .loaded(users)
        } catch {
            loadingState = .error(error.localizedDescription)
            print("DEBUG: fetching users \(error)")
        }
    }
    
    /// Creates a user and inserts it into the loaded list (or starts a new loaded list).
    func createUser(_ payload: User) async {
        do {
            let newUser = try await service.create(payload)
            insertOrStart(newUser)
        } catch {
            print("DEBUG: updating users \(error)")
        }
    }
    
    /// Updates a user and replaces the local copy when the list is loaded.
    func updateUser(_ id: Int, payload: UpdateUser) async {
        do {
            let updatedUser = try await service.update(id, payload: payload)
            updateUserIfLoaded(updatedUser)
        } catch {
            print("DEBUG: updating users \(error)")
        }
    }
    
    private func insertOrStart(_ user: User) {
        switch loadingState {
        case .loaded(var users):
            users.insert(user, at: 0)
            loadingState = .loaded(users)
        default:
            loadingState = .loaded([user])
        }
    }
    
    private func updateUserIfLoaded(_ user: User) {
        guard case .loaded(var users) = loadingState else {
            return
        }
        guard let index = users.firstIndex(where: { $0.id == user.id }) else { return }
        users[index] = user
        loadingState = .loaded(users)
    }
    
}
