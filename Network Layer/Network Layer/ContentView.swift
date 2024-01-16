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
