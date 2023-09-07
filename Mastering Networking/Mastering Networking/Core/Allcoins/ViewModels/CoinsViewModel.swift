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
    
    private let service = CoinDataService()
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        service.fetchCoins { coins in
            self.coins = coins
        }
    }
    
}
