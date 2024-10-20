import UIKit
import PlaygroundSupport

protocol APIClient {
    func get<T: Decodable>(url: URL) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
}

final class NetworkManager: APIClient {
    
    private let urlCache: URLCache
    
    init(urlCache: URLCache = .shared) {
        self.urlCache = urlCache
    }
    
    func get<T: Decodable>(url: URL) async throws -> T {
        if let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            let decodedData = try JSONDecoder().decode(T.self, from: cachedResponse.data)
            return decodedData
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        }
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
