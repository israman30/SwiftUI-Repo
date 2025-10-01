//
//  ContentView.swift
//  Base Architecture
//
//  Created by Israel Manzo on 10/1/25.
// https://jsonplaceholder.typicode.com/users

import SwiftUI

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
