//
//  ContentView.swift
//  Memory Usage Implementation
//
//  Created by Israel Manzo on 10/18/24.
//

import SwiftUI

class SomeViewModel: ObservableObject {
    
}

struct ContentView: View {
    
    @StateObject var someViewModel = SomeViewModel()
    
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
