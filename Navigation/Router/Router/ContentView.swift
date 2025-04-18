//
//  ContentView.swift
//  Router
//
//  Created by Israel Manzo on 4/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button {
                
            } label: {
                Text("Login")
                    .padding(.horizontal)
            }
            .buttonStyle(.bordered)
            .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
