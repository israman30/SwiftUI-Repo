import Foundation

// MARK: - Networking + API shape
// This project uses JSONPlaceholder because it supports simple, predictable pagination via
// `_page` and `_limit` query params. In a real API you might use cursors, `nextPageToken`,
// or a Link header; the rest of the app is structured so the paging logic lives above the service.

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL."
        case .invalidResponse:
            "Invalid server response."
        case .httpStatus(let code):
            "Request failed with status code \(code)."
        }
    }
}

struct Post: Decodable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol PostsServicing {
    /// Fetch a single "page" of posts.
    /// - Parameters:
    ///   - page: 1-based page index.
    ///   - limit: page size (items per request).
    func fetchPosts(page: Int, limit: Int) async throws -> [Post]
}

struct JSONPlaceholderPostsService: PostsServicing {
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    func fetchPosts(page: Int, limit: Int) async throws -> [Post] {
        // JSONPlaceholder pagination: `GET /posts?_page=N&_limit=K`
        var components = URLComponents(url: baseURL.appendingPathComponent("posts"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "_page", value: String(page)),
            URLQueryItem(name: "_limit", value: String(limit))
        ]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.httpStatus(http.statusCode)
        }
        
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

