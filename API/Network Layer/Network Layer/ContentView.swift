//
//  ContentView.swift
//  Network Layer
//
//  Created by Israel Manzo on 1/15/24.
//

import SwiftUI

public enum NetworkError: Error {
    case invalidURL
    case failedWithError(_ code: Int)
    case failed
}

public enum NetworkMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public struct NetworkAPIRequest {
    var resource: String
    var method: NetworkMethod
    var headers: [String:String]?
    var queryParmans: [String:Any]?
    var body: Data?
    
    public init(resource: String, method: NetworkMethod = .GET, headers: [String : String]? = nil, queryParmans: [String : Any]? = nil, body: Data? = nil) {
        self.resource = resource
        self.method = method
        self.headers = headers
        self.queryParmans = queryParmans
    }
}


public protocol NetworkingProtocol {
    func doTask<T: Decodable>(api request: NetworkAPIRequest) async -> Result<T, Error>
}

public final class NetworkServices: NetworkingProtocol {
    
    public static let `default` = NetworkServices()
    
    private let configuration = URLSessionConfiguration.default
    private let session: URLSession
    public var baseURL = "https://jsonplaceholder.typicode.com"
    
    init() {
        configuration.timeoutIntervalForRequest = 60
        configuration.httpAdditionalHeaders = ["Content-Type":"application/json"]
        session = URLSession(configuration: configuration)
    }
    
    private func prepareURL(url request: NetworkAPIRequest) -> URL? {
        var urlComponents = URLComponents(string: "\(baseURL)/\(request.resource)")
        let queryItems = request.queryParmans?.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    public func getURLRequest(url: URL, request: NetworkAPIRequest) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers
        return urlRequest
    }
    
    public func doTask<T: Decodable>(api request: NetworkAPIRequest) async -> Result<T, Error> {
        guard let url = prepareURL(url: request) else {
            return .failure(NetworkError.invalidURL)
        }
        let urlRequest = getURLRequest(url: url, request: request)
        do {
            let (data, _) = try await session.data(for: urlRequest)
            if let model = try? JSONDecoder().decode(T.self, from: data) {
                return .success(model)
            }
            
        } catch let error {
            return .failure(error)
        }
        return .failure(NetworkError.failed)
    }
}

@MainActor
class ViewModel: ObservableObject {
    @Published var response: Result<[Post], Error>?
    @Published var isLoading = false
    private let networkServices: NetworkServices
    
    init(networkServices: NetworkServices) {
        self.networkServices = networkServices
    }
    
    func getPosts() async {
        let request = NetworkAPIRequest(resource: "POST")
        let response: Result<[Post], Error> = await networkServices.doTask(api: request)
        self.response = response
        self.isLoading = false
    }
}

struct Post: Decodable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
}

struct ContentView: View {
    
    @StateObject private var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkServices: NetworkServices()))
    }
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
            } else {
                if let response = vm.response {
                    switch response {
                    case .success(let posts):
                        ScrollView {
                            ForEach(posts, id: \.id) { post in
                                VStack {
                                    Text(post.title)
                                }
                            }
                        }
                    case .failure(let fail):
                        Text(fail.localizedDescription)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                await vm.getPosts()
            }
        }
    }
}

#Preview {
    ContentView()
}
