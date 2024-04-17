//
//  CoinsViewModel.swift
//  Mastering Networking
//
//  Created by Israel Manzo on 9/6/23.
//

import Foundation
import SwiftUI

@MainActor
class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        Task {
            try await fetchCoins()
        }
    }
    
    func fetchCoins() async throws {
        self.coins = try await service.fetchCoins()
    }
    
    func fetchCoinsWithCompletion() {
        service.fetchCoinsWithResult { [weak self] result in
            switch result {
            case .success(let coins):
                self?.coins = coins
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
}
