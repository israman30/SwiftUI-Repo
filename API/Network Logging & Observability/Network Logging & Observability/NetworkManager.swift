//
//  NetworkManager.swift
//  Network Logging & Observability
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct NetworkManager {
    
    private let logger = NetworkLogger.shared
    
    func fetchPost() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        logger.logRequest(url)
        
        guard let url else {
            throw URLError(.badURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            logger.logResponse(response, data: data, url: url)
            
            guard let response = response as? HTTPURLResponse,
                  (200...300).contains(response.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let posts = try JSONDecoder().decode([Post].self, from: data)
            
            logger.logDecoder(Post.self, count: posts.count)
            
            return posts
        } catch {
            logger.logError(error, url: url)
            throw error
        }
    }
}
