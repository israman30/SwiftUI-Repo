//
//  ContentView.swift
//  Navigation Transition
//
//  Created by Israel Manzo on 8/29/25.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                Text("Destination View")
                    .navigationTransition(.zoom(sourceID: "2", in: namespace))
            } label: {
                Text("Go to Destination")
                    .matchedTransitionSource(id: "1", in: namespace)
            }
        }
    }
}

#Preview {
    ContentView()
}
