//
//  ContentView.swift
//  DI with Unit Testing and Combine
//
//  Created by Israel Manzo on 6/25/23.
//

import SwiftUI
import Combine

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

class NetworkServices {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/user") else { return }
    
    func getUsers() -> AnyPublisher<[User], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
