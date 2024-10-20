import UIKit
import PlaygroundSupport

protocol APIClient {
    func get<T: Decodable>(url: URL) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
}

final class NetworkManager: APIClient {
    func get<T: Decodable>(url: URL) async throws -> T {
        
    }
    
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        
    }
}
