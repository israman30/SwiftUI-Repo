//
//  ContentView.swift
//  View Modifiers
//
//  Created by Israel Manzo on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var isActive = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .heading1()
            
            VStack {
                Text("Card Shadow")
                    .font(.title2)
            }
            .padding()
            .background(Color.yellow)
            .cardShadow()
            
            VStack {
                Text("Align Modifier")
                    .font(.title2)
                    .fullWidth()
            }
            .padding()
            .background(Color.yellow)
            .cardShadow()
            
            Text("Condition")
                .if(isActive) { content in
                    content
                        .background(Color.red)
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
