//
//  UserList.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

/// Displays users using `LoadingState` as the single source of truth for rendering.
///
/// The view model publishes `loadingState`, and the view switches on it to decide whether to show
/// a spinner, an empty state, the list of users, or an error message.
struct UserList: View {
    @StateObject var vm = UserViewModel(service: UserService())
    var body: some View {
        Group {
            switch vm.loadingState {
            case .idle, .loading:
                ProgressView()
            case .empty:
                Text("No users to display")
            case .loaded(let users):
                List(users) { user in
                    Text(user.name)
                }
            case .error(let errorMessage):
                Text(errorMessage)
            }
        }
        .task {
            await vm.loadUsers()
        }
    }
    
    func addUser() {
        
    }
}

#Preview {
    UserList()
}
