//
//  NetworkViewModel.swift
//  Networking with Combine
//
//  Created by Israel Manzo on 1/20/23.
//

import Foundation
import Combine
import SwiftUI

class NetworkViewModel: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    private var network: NetworkServices2 = .shared
    @Published var users = [User]()
    
    func getUsers() {
        network
            .getData(endpoint: .users, type: User.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error Sinking user: \(error.localizedDescription)")
                case .finished:
                    print("Finish getting users")
                }
            } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellable )

    }
}
