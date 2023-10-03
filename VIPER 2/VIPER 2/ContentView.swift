//
//  ContentView.swift
//  VIPER 2
//
//  Created by Israel Manzo on 10/2/23.
//

import SwiftUI

// "https://pokeapi.co/api/v2/pokemon?limit=20"

struct Pokemon: Decodable, Identifiable {
    var id = UUID().uuidString
    let name: String
}

final class NetworkServices {
    func fetchData() async throws -> [Pokemon] {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else {
            fatalError("DEBUG: Bad url address")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
            fatalError("DEBUG: Bad response with")
        }
        
        return try JSONDecoder().decode([Pokemon].self, from: data)
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
