import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
    func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let paramenters = parameters {
            if method == .get {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = paramenters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components?.url
            } else {
                request.httpBody = try JSONSerialization.data(withJSONObject: paramenters)
            }
        }
        return request
    }
}

enum NetworkError: Error {
    case invalidateResponse
    case decondingFailed
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError(statusCode: Int)
}

extension NetworkError {
    var errorDescription: String? {
        switch self {
        case .invalidateResponse:
            return "Invalid response"
        case .decondingFailed:
            return "Decoding failed"
        case .clientError(statusCode: let code):
            return "Client error: \(code)"
        case .serverError(statusCode: let code):
            return "Server error: \(code)"
        case .unknownError:
            return "Unknown error"
        }
    }
}

protocol NetworkManager {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class NetworkManagerImplementation: NetworkManager {
    @MainActor
    static let shared = NetworkManagerImplementation()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidateResponse
        }
        
        try invalid(httpResponse)
        
        do {
            let decode = JSONDecoder()
            return try decode.decode(T.self, from: data)
        } catch {
            throw NetworkError.decondingFailed
        }
        
    }
    
    private func invalid(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...399:
            return
        case 400...599:
            throw NetworkError.clientError(statusCode: response.statusCode)
        case 600...799:
            throw NetworkError.serverError(statusCode: response.statusCode)
        default:
            throw NetworkError.unknownError(statusCode: response.statusCode)
        }
    }
}

// MARK: --- List Endpoint ---
struct ListEndpoint: Endpoint {
    var baseURL: URL {
        .init(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        "/todos"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String:String]? {
        ["Content-Type":"application/json"]
    }
    
    var parameters: [String:Any]? {
        nil
    }
}

// MARK: --- Single endpoint ---
struct SingleEndpoint: Endpoint {
    let id: Int
    
    var baseURL: URL {
        .init(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        "/todos/\(id)"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String : Any]? {
        nil
    }
}

// MARK: --- Some endpoint ---
struct Todo: Decodable {
    let id: Int
    let title: String
    let completed: Bool
}

struct SomeEndpoint: Endpoint {
    let todo: Todo
    
    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        "/todos"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String : Any]? {
        [
            "title": todo.title,
            "completed": todo.completed
        ]
    }
}
