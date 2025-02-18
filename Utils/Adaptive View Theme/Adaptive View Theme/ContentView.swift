//
//  ContentView.swift
//  Adaptive View Theme
//
//  Created by Israel Manzo on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AdaptiveView {
                Text("Hello, world!")
                    .font(.largeTitle)
            } dark: {
                Text("Hello, world!")
                    .font(.largeTitle)
            }

            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

// Used for custom components for support light and dark theme.
struct AdaptiveView<T: View, U: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let light: T
    let dark: U
    
    init(light: T, dark: U) {
        self.light = light
        self.dark = dark
    }
    
    init(light: () -> T, dark: () -> U) {
        self.light = light()
        self.dark = dark()
    }
    
    @ViewBuilder
    var body: some View {
        switch colorScheme {
        case .light:
            light
        default:
            dark
        }
    }
}
