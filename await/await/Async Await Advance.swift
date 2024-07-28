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


// MARK: - Concurrent Data Fetching

func fethcMultipleData() async {
    async let dataA = Network().fetchData(url: "example.com/A")
    async let dataB = Network().fetchData(url: "example.com/B")
    async let dataC = Network().fetchData(url: "example.com/C")
    async let dataD = Network().fetchData(url: "example.com/D")
    
    do {
        let results = try await (dataA, dataB, dataC, dataD)
        print("Results: ", results)
    } catch {
        print("Error fetching data", error.localizedDescription)
    }
}

// MARK: - Handling Timeouts and Cancellation

func fetchWithTimeOut(url: String) async throws -> Data {
    let task = Task {
        try await Network().fetchData(url: url)
    }
    let timeoutTask = Task {
        try await Task.sleep(nanoseconds: 5_000_000)
        task.cancel()
    }
    return try await task.value
}

func fetching() {
    Task {
        do {
            let data = try await Network().fetchData(url: "example.com")
        } catch {
            print("Operation timeout was cancelled: ", error.localizedDescription)
        }
    }
}
