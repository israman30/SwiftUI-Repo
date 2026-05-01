//
//  APIClient.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

/// Minimal URLSession-based API client responsible for executing `APIRequest` values.
///
/// Responsibilities:
/// - Build a `URLRequest` from `APIRequest` (base URL + typed route + query + headers + body)
/// - Execute the request using `URLSession`
/// - Validate HTTP status codes (treat 2xx as success)
/// - Decode JSON responses into `Decodable` models
///
/// Injectability:
/// - `session` can be swapped for tests
/// - `decoder` can be customized (date strategies, key decoding, etc.)
struct APIClient {
    /// Base URL (scheme + host) used to resolve `APIRequest.path` into a full URL.
    let baseUrl: URL
    
    /// Underlying transport. Defaults to `URLSession.shared` for this sample.
    var session: URLSession = .shared
    
    /// Decoder used for all responses executed by this client.
    var decoder: JSONDecoder = .init()
    
    /// Executes an `APIRequest` and decodes the response into the requested `Response` type.
    ///
    /// - Note: On non-2xx responses, this sample prints the response body (when UTF-8) to aid debugging
    ///   and throws `URLError(.badServerResponse)`.
    func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        do {
            let request = try requestModel.makeUrlRequest(baseURL: baseUrl)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.httpStatus(code: httpResponse.statusCode)
            }
            return try decoder.decode(Response.self, from: data)
        } catch {
            let mappedError = NetworkErrorMapper.map(error)
            throw mappedError
        }
    }
}
