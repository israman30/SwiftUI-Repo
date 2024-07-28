//
//  Async Await Advance.swift
//  await
//
//  Created by Israel Manzo on 7/27/24.
//

import SwiftUI

class Network {
    
    func fetchData(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

struct SomeOtherClass: View {
    var body: some View {
        Text("Fetching some data")
            .task {
                do {
                    let data = try await Network().fetchData(url: "www.google.com")
                    print("Fetched data: ", data)
                } catch {
                    print("Failed fetching data")
                }
            }
    }
}
