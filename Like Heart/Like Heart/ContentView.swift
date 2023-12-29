//
//  ContentView.swift
//  Like Heart
//
//  Created by Israel Manzo on 12/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LikeView()
    }
}

#Preview {
    ContentView()
}

struct LikeView: View {
    
    @State var isLiked = false
    @State var scaleValue = 1.0
    
    var body: some View {
        Button {
            self.isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 50, height: 50)
                .scaleEffect(isLiked ? 1.2 : 1)
                .animation(.linear(duration: 0.2), value: isLiked)
                .brightness(isLiked ? -0.05 : 0)
                .foregroundStyle(isLiked ? .red : .gray)
            
        }
        
            
    }
}
