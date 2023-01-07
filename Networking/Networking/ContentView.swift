//
//  ContentView.swift
//  Networking
//
//  Created by Israel Manzo on 1/6/23.
//

import SwiftUI

//https://jsonplaceholder.typicode.com/users

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

class NetworkServices {
    
    static let shared = NetworkServices()
    
    func fetchUser() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                return
            }
            
        }
        task.resume()
    }
}
