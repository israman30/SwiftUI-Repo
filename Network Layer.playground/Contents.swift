import SwiftUI

// MARK: --- NETWORK LAYER ---
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

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
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

struct CreateTodoEndpoint: Endpoint {
    let newTodo: Todo
    
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
            "title": newTodo.title,
            "completed": newTodo.completed
        ]
    }
}

// MARK: --- Some endpoint ---
struct Todo: Decodable, Identifiable {
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

// MARK: -- Implementation --
class SomeViewModel: ObservableObject {
    @Published var todos = [Todo]()
    @Published var error: NetworkError?
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchTodos() async {
        do {
            self.todos = try await networkManager.fetch(from: ListEndpoint())
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
    
    func fetchSingleObject(id: Int) async {
        do {
            let todo: Todo = try await networkManager.fetch(from: SingleEndpoint(id: id))
            self.todos.append(todo)
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
    
    func createObject(todo: Todo) async {
        let newTodo = Todo(id: 0, title: todo.title, completed: false)
        do {
            let createdTodo: Todo = try await networkManager.fetch(from: CreateTodoEndpoint(newTodo: todo))
            self.todos.append(createdTodo)
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
}

// MARK: -- View --

struct ContentView: View {
    @StateObject private var viewModel = SomeViewModel(networkManager: NetworkManager())
    
    var body: some View {
        NavigationView {
            Group {
                if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                } else {
                    List(viewModel.todos) { todo in
                        HStack {
                            Text(todo.title)
                            Spacer()
                            if todo.completed {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchTodos()
        }
    }
}
