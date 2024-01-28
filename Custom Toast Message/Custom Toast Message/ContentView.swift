//
//  ContentView.swift
//  Custom Toast Message
//
//  Created by Israel Manzo on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .font(.title)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(15.0)
        .shadow(radius: 10, y: 7)
    }
}

#Preview {
    ContentView()
}
