//
//  NetworkServices.swift
//  Networking with Combine
//
//  Created by Israel Manzo on 1/12/23.
//

import SwiftUI
import Combine

enum APIError: Error {
    case errorResponse
}

protocol NetworkServices {
    func fetchUsers() -> AnyPublisher<AnyObject, Error>
}

//final class NetworkServicesImplementation: NetworkServices {
//
//    struct Response<T> {
//        let value: T
//        let response: URLResponse
//    }
//
//    func fetchUsers<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
//
//    }
//}
/**
 1. We request data from a URL, in case you need to provide a header or body you can also use a URLRequest.
 2. We make sure we are on RunLoop.main this is important if we want to perform UI updates with the result.
 3. We unpack the data from the response. In case it is nil the pipeline will stop and a failure is reported.
 4. We decode our JSON data with the help of Codable. If you need more information on that you can check out my last post.
 5. Finally we convert this pipeline to AnyPublisher which flattens the types and makes our result type easily accessible.
 */
enum DataLoader {
    static func loadUser(from url: URL) -> AnyPublisher<[User], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

final class NetworkServicesImplementation: ObservableObject {
    
    @Published private(set) var users = [User]()
    
    private var cancellable: Cancellable?
    
    func load() {
        cancellable?.cancel()
        
        guard let url = URL(string: Constants.endopint) else { return }
        
        cancellable = DataLoader.loadUser(from: url)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.users = result
            }
    }
}
