//
//  APIRequest.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Supported HTTP verbs for building `URLRequest` values.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Placeholder response model for endpoints that return an empty JSON object.
///
/// Note: If an endpoint returns a truly empty body (`0` bytes), decoding may fail unless the caller
/// special-cases that scenario. This sample targets APIs that return `{}` for "empty" responses.
struct EmptyRespons: Decodable {
    
}

/// A lightweight description of an HTTP request that can be converted into `URLRequest`.
///
/// This keeps request construction (method/path/query/headers/body) separate from execution so it’s:
/// - easy to unit test
/// - easy to reuse across multiple services
/// - straightforward to extend (auth headers, retries, etc.)
struct APIRequest<Response: Decodable> {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]
    var header: [String: String] = [:]
    var body: Data?
    
    /// Creates a request with a pre-encoded HTTP body.
    init(method: HTTPMethod, path: String, queryItems: [URLQueryItem] = [], header: [String : String] = [:], body: Data? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.header = header
        self.body = body
    }
    
    /// Creates a request with an `Encodable` body encoded as JSON.
    ///
    /// If the caller didn't specify `"Content-Type"`, this initializer sets it to `"application/json"`.
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
    
    /// Converts this model into a `URLRequest` using a base URL.
    ///
    /// - Parameters:
    ///   - baseURL: Base host URL such as `https://example.com/`.
    ///   - defaultHeaders: Headers applied to all requests (e.g. auth), overridden by request-specific headers.
    /// - Returns: A fully-formed `URLRequest` ready to be executed by `URLSession`.
    func makeUrlRequest(baseURL: URL, defaultHeaders: [String:String] = [:]) throws -> URLRequest {
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
        // Request-specific headers win over defaults (e.g. per-call Content-Type or custom flags).
        mergeHeader.merge(header) { (_, new) in new }
        request.allHTTPHeaderFields = mergeHeader
        request.httpBody = body
        
        return request
    }
}
