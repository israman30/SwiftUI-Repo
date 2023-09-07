//
//  CoinsViewModel.swift
//  Mastering Networking
//
//  Created by Israel Manzo on 9/6/23.
//

import Foundation
import SwiftUI

class CoinsViewModel: ObservableObject {
    
    @Published var coins = ""
    @Published var price = ""
    
    init() {
        fetchPrice(coin: "litecoin")
    }
    
    func fetchPrice(coin: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else { return }
            guard let value = jsonObject[coin] as? [String:Double] else { return }
            guard let price = value["usd"] else { return }
            DispatchQueue.main.async {
                self.coins = coin.capitalized
                self.price = "\(price)"
            }
            
        }.resume()
    }
    
}
