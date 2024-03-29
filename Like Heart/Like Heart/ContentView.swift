//
//  ContentView.swift
//  Like Heart
//
//  Created by Israel Manzo on 12/28/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLiked = false
    
    var body: some View {
        HeartLikeView(isLiked: $isLiked)
    }
}

#Preview {
    ContentView()
}

struct HeartLikeView: View {
    
    @Binding var isLiked: Bool
    @State var animationAmount = 1.0
    
    private let animationDuration = 0.1
    
    private var animationScale: CGFloat {
        isLiked ? 0.7 : 1.3
    }
    
    @State private var isAnimating = false
    
    var body: some View {
        Button {
            self.executeButtonAnimation()
        } label: {
            VStack {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(isLiked ? .red : .gray)
            }
            .scaleEffect(isAnimating ? animationScale : 1)
            .animation(.easeInOut(duration: animationDuration), value: animationDuration)
        }
    }
    
    private func executeButtonAnimation() {
        self.isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isAnimating = false
            self.isLiked.toggle()
        }
    }
}
