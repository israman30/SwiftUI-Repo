//
//  ContentView.swift
//  Container Presenting Pattern
//
//  Created by Israel Manzo on 9/12/25.
//
// source: https://www.patterns.dev/react/presentational-container-pattern/
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
