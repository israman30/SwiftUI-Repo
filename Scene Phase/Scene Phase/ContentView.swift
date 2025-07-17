//
//  ContentView.swift
//  Scene Phase
//
//  Created by Israel Manzo on 7/16/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment
    
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
