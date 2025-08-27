//
//  ContentView.swift
//  Concurrency and Alamofire
//
//  Created by Israel Manzo on 8/26/25.
//

import SwiftUI
import Alamofire

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let data = try Data(contentsOf: url)
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate()
                .responseDecodable(of: [User].self) { response in
                    switch response.result {
                    case .success(let users):
                        continuation.resume(returning: users)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
