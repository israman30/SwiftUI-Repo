//
//  APIRequest.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct APIRequest<Response: Decodable> {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]
    var header: [String: String] = [:]
    var body: Data?
    
    init(method: HTTPMethod, path: String, queryItems: [URLQueryItem] = [], header: [String : String] = [:], body: Data? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.header = header
        self.body = body
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, queryItems: [URLQueryItem] = [], header: [String : String] = [:], encoder: JSONEncoder = JSONEncoder(), body: Body) throws {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.header = header
        self.body = try encoder.encode(body)
        
        if self.header["Content-Type"] == nil {
            self.header["Content-Type"] = "application/json"
        }
    }
    
    func makeUrlRequest(baseURL: URL, defaultHeaders: [String:String]) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var mergeHeader = defaultHeaders
        mergeHeader.merge(header) { (_, new) in new }
        request.allHTTPHeaderFields = mergeHeader
        request.httpBody = body
        
        return request
    }
}
