//
//  NetworkHandler.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import Foundation

enum NetworError: Error {
    case userError
    case dataError
    case encodingError, decodingError
    case failStatusCode
    case failStatusCodeResponseData(Int, Data)
    case noResponse
    
    var statuCodeResponseData: (Int, Data)? {
        if case let .failStatusCodeResponseData(statusCode, responseData) = self {
            return (statusCode, responseData)
        }
        return nil
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
}

final class NetworkHandler {
    
    func request(_ url: URL, jsonDictionary: Any? = nil, httpMethod: String = HTTPMethod.get.rawValue, contentType: String? = ContentType.json.rawValue, accessToken: String? = nil) async throws -> Data {
        var urlRequest = makeURLRequestHeader(url, httpMethod: httpMethod, contentType: contentType, accessToken: accessToken)
        
        if let jsonDictionary, let httpBody = try? JSONSerialization.data(withJSONObject: jsonDictionary) {
            urlRequest.httpBody = httpBody
        } else if jsonDictionary != nil {
            print("Could not serialize json")
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Could not create HTTPRequest: \(urlRequest.url?.absoluteString ?? "")")
            fatalError()
        }
        return data
    }
    
    func makeURLRequestHeader(_ url: URL, httpMethod: String = HTTPMethod.get.rawValue, contentType: String? = ContentType.json.rawValue, accessToken: String? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        if let contentType = contentType {
            urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            if contentType.range(of: "json") != nil {
                urlRequest.addValue(contentType, forHTTPHeaderField: "Accept")
            }
        }
        
        if let accessToken = accessToken {
            let authKey = "Bearer".appending(accessToken)
            urlRequest.addValue(authKey, forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}

struct SecureFetchData: Codable {
    let message: String
}
