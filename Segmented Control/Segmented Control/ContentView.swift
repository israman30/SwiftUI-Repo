//
//  ContentView.swift
//  Segmented Control
//
//  Created by Israel Manzo on 8/29/25.
//

import SwiftUI

enum Segement: String, CaseIterable, Identifiable {
    case swift
    case uikit
    case swiftUI
    
    var id: String { self.rawValue}
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
