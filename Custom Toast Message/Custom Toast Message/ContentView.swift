//
//  ContentView.swift
//  Custom Toast Message
//
//  Created by Israel Manzo on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var execute = false
    @State var isVisible = false
    
    var body: some View {
        VStack {
            CustomToastView(text: "Toast", isVisible: $isVisible)
            
            Button {
                self.isVisible = true
            } label: {
                Text("Event")
            }
            .buttonStyle(.bordered)
        }
       
    }
}

#Preview {
    ContentView()
}


struct CustomToastView: View {
    var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            if isVisible {
                toastText
            }
            Spacer()
        }
    }
    
    private var toastText: some View {
        VStack {
            Text(text)
                .font(.title3)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(15.0)
        .shadow(radius: 10, y: 7)
        .onAppear(perform: delayText)
        .transition(AnyTransition.opacity.animation(.easeInOut(duration:0.5)))
    }
    
    private func delayText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isVisible = false
            }
        }
    }
}
