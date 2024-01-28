//
//  ContentView.swift
//  Custom Toast Message
//
//  Created by Israel Manzo on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        CustomToastView(text: "Toast")
    }
}

#Preview {
    ContentView()
}


struct CustomToastView: View {
    @State private var isVisible = false
    var text: String
    
    var body: some View {
        VStack {
            if isVisible {
                VStack {
                    Text(text)
                        .font(.title3)
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(15.0)
                .shadow(radius: 10, y: 7)
                .onAppear(perform: delayText)
            }
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isVisible = true
                }
            } label: {
                Text("Tap me")
            }
            .padding(.vertical)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        
        
    }
    
    private func delayText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isVisible = false
            }
        }
    }
}
