//
//  NetworkServices2.swift
//  Networking with Combine
//
//  Created by Israel Manzo on 1/19/23.
//

import Foundation
import Combine

enum Endpoint: String {
    case users
    case posts
}

enum NetworkError: Error {
    case badUrl
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

class NetworkServices2 {
    
    static let shared = NetworkServices2()
    
    private init() {}
    
    private var cancellables = Set<AnyCancellable>()
    private let baseUrl = Constants.endopint
    
    func getData<T: Decodable>(endpoint: Endpoint, id: Int? = nil, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.baseUrl) else {
                return promise(.failure(NetworkError.badUrl))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { promise(.success($0)) }
                .store(in: &self.cancellables)

        }
    }
    
}


