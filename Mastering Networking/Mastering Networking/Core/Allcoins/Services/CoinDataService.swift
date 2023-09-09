//
//  CoinDataService.swift
//  Mastering Networking
//
//  Created by Israel Manzo on 9/7/23.
//

import Foundation

protocol CoinsDataServicesProtocol {
    func fetchCoins() async throws -> [Coin]
}

// https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=3&page=1&sparkline=false&price_change_percentage=24h&locale=en
//@MainActor
class CoinDataService: CoinsDataServicesProtocol {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=3&page=1&sparkline=false&price_change_percentage=24h&locale=en"
    
    
    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if data.isEmpty { throw CoinAPIError.invalidData }
            
            guard response is HTTPURLResponse else {
                throw CoinAPIError.requesFailed(description: "Request Failed")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode ~= 200 else {
                throw CoinAPIError.badResponse
            }
            
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
            return []
        }
    }
    
}

// MARK: - Completion handlers
extension CoinDataService {
    func fetchCoinsWithResult(completion: @escaping(Result<[Coin], CoinAPIError>)->Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requesFailed(description: "Request Failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(coins))
                }
            } catch {
                print("DEBUG: Failed to dedcode with error: \(error)")
                completion(.failure(.jsonParsinFailure))
            }
            
        }.resume()
    }
    
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                return
            }
            
            print("DEBUG: Response status code: \(httpResponse.statusCode)")
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else { return }
            guard let value = jsonObject[coin] as? [String:Double] else { return }
            guard let price = value["usd"] else { return }
            //                self.coins = coin.capitalized
            print("DEBUG: price in service class: \(price)")
            DispatchQueue.main.async {
                completion(price)
            }
            
        }.resume()
    }
}
