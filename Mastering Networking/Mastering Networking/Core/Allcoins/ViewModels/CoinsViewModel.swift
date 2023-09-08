//
//  CoinsViewModel.swift
//  Mastering Networking
//
//  Created by Israel Manzo on 9/6/23.
//

import Foundation
import SwiftUI

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        service.fetchCoinsWithResult { [weak self] result in
            switch result {
            case .success(let coins):
                self?.coins = coins
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
//        service.fetchCoins { coins, error in
//            if let error = error {
//                self.errorMessage = error.localizedDescription
//                return
//            }
//            self.coins = coins ?? []
//        }
    }
    
}
