import UIKit

enum NetworkError: Error {
    case internalError(_ error: Int)
    case serverError(_ error: Int)
}

protocol NetworkProtocol {
    func fectch<T>(_ url: URL) async throws -> T where T: Decodable
}

final class NetworkManager: NetworkProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fectch<T>(_ url: URL) async throws -> T where T: Decodable {
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300) ~= httpResponse.statusCode else {
            switch (response as! HTTPURLResponse).statusCode {
            case (400...499):
                throw NetworkError.internalError((response as! HTTPURLResponse).statusCode)
            default:
                throw NetworkError.serverError((response as! HTTPURLResponse).statusCode)
            }
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
