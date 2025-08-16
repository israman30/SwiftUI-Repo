//
//  ContentView.swift
//  NavigationStack + Deep Linking
//
//  Created by Israel Manzo on 8/15/25.
//

import SwiftUI
import Observation

enum FlightRoute: String, Identifiable {
    case home
    case destination
    
    var id: String { rawValue }
}

struct ContentView: View {
    
    var body: some View {
       Text("Hello World")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
