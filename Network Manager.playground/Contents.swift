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

// MARK: - Usage

struct SampleObject: Decodable, Identifiable {
  var id = UUID()
  let name: String
}

class ViewModel: ObservableObject {
    @Published var someObject: [SampleObject] = []
    private let apiClient: APIClient

    init(apiClient: APIClient = NetworkManager()) {
        self.apiClient = apiClient
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://api.example.com/data") else { return }
        
        do {
            let fetchedData: [SampleObject] = try await apiClient.get(url: url)
            DispatchQueue.main.async {
                self.someObject = fetchedData
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}
