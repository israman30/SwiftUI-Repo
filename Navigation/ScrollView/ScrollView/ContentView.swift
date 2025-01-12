//
//  ContentView.swift
//  ScrollView
//
//  Created by Israel Manzo on 1/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var scrollPosition = ScrollPosition()
    
    let colors: [Color] = [
        .red, .green, .blue, .yellow, .cyan, .pink, .purple, .gray, .brown, .orange, .indigo, .mint, .primary, .secondary
    ]
    
    var body: some View {
        ZStack(alignment:. bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(width: 360, height: 240)
                            .cornerRadius(10)
                    }
                }
            }
            .scrollPosition($scrollPosition)
            .animation(.spring, value: scrollPosition)
            
            buttons
        }
    }
    
    private var buttons: some View {
        VStack {
            Button {
                scrollPosition.scrollTo(edge: .top)
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white, .black)
            }
            
            Button {
                scrollPosition.scrollTo(edge: .bottom)
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white, .black)
            }
            
            Button {
                
            } label: {
                Image(systemName: "arrow.up.and.down.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white, .black)
            }
        }
    }
}

#Preview {
    ContentView()
}
