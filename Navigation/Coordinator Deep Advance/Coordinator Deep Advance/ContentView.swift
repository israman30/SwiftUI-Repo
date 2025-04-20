//
//  ContentView.swift
//  Coordinator Deep Advance
//
//  Created by Israel Manzo on 4/19/25.
//

import SwiftUI
/**
 The `Coordinator Pattern` is a design pattern used to manage the navigation flow and communication between view controllers (or views in SwiftUI). The core idea is to move navigation logic out of the views and centralize it into separate coordinator objects.
 */

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
