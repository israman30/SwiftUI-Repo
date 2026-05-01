//
//  APIClient.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

struct APIClient {
    /// Executes an `APIRequest` and decodes the response into the requested type.
    ///
    /// Pipeline:
    /// - Build `URLRequest` from base URL + path/query/headers/body
    /// - Perform the request via `URLSession`
    /// - Validate HTTP status code (2xx success)
    /// - Decode JSON into `Response`
    
    let baseUrl: URL
    var session: URLSession = .shared
    var decoder: JSONDecoder = .init()
    
    func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        let request = try requestModel.makeUrlRequest(baseURL: baseUrl)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            // For debugging: capture server-provided error payload if it’s UTF-8.
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Failed: \(httpResponse.statusCode) - \(bodyString)")
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(Response.self, from: data)
    }
}
