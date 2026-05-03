//
//  NetworkManager.swift
//  Network Logging & Observability
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

/// Minimal network client for this sample app.
///
/// `NetworkManager` demonstrates an async/await request flow using `URLSession`, with end-to-end
/// request/response observability through `NetworkLogger` (request metadata, response status/body,
/// decoding success, and failures).
struct NetworkManager {
    
    private let logger = NetworkLogger.shared
    
    /// Fetches posts from the JSONPlaceholder `/posts` endpoint.
    ///
    /// The request and response are logged via `NetworkLogger`, and the response body is decoded as
    /// `[Post]`.
    ///
    /// - Returns: An array of `Post` decoded from the response JSON.
    /// - Throws: `URLError(.badURL)` if the endpoint URL is invalid, `URLError(.badServerResponse)`
    ///   if the HTTP status code is not successful, or any error surfaced by `URLSession`/decoding.
    /// - Note: This method does not guarantee execution on the main thread. If you update UI with
    ///   the result, hop back to the `MainActor`.
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
                  (200...299).contains(response.statusCode) else {
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
