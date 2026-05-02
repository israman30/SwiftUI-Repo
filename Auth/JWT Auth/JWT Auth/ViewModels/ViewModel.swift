//
//  ViewModel.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI
import Combine

@MainActor
final class ViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var errorMessage: String?
    
    private var services: NetworkManager
    
    init(services: NetworkManager) {
        self.services = services
    }
    
    func loadUsers() async {
        do {
            errorMessage = nil
            self.users = try await services.fetchUsers()
        } catch {
            if let apiError = error as? APIError, apiError == .unauthorized {
                errorMessage = "Unauthorized. Please sign in."
            } else {
                errorMessage = "Something went wrong."
            }
        }
    }
}
