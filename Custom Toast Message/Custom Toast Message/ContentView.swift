//
//  ContentView.swift
//  Custom Toast Message
//
//  Created by Israel Manzo on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 50) {
            
            if isVisible {
                CustomToastView(text: "Toast Message")
            }
            
            Button {
                isVisible = true
            } label: {
                Text("Tap me")
                    .font(.title)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}


struct CustomToastView: View {
    
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.title3)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(15.0)
        .shadow(radius: 10, y: 7)
    }
}
