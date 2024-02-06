//
//  ContentView.swift
//  Custom Toast Message
//
//  Created by Israel Manzo on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isVisible = false
    
    var body: some View {
        VStack {
            CustomToastView(text: "This is a very Toast long message just for testing", isVisible: $isVisible)
            
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
    var delayedAnimation: CGFloat = 2
    var animationDuration: CGFloat = 0.3
    
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
        .padding(.vertical, 10)
        .padding(.horizontal, 25)
        .background(Color(.systemGray5))
        .cornerRadius(15.0)
        .shadow(radius: 10, y: 7)
        .onAppear(perform: delayText)
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: animationDuration)))
        .accessibilityIdentifier("Toast_Text")
    }
    
    private func delayText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayedAnimation) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                self.isVisible = false
            }
        }
    }
}
