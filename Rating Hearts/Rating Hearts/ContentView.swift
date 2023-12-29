//
//  ContentView.swift
//  Rating Hearts
//
//  Created by Israel Manzo on 12/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StarsView(rating: 1.7, maxRating: 5)
    }
}

#Preview {
    ContentView()
}

struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int

    var body: some View {
        hearts
            .overlay(
            GeometryReader {
                let width = rating / CGFloat(maxRating) * $0.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.red)
                }
            }
            .mask(hearts)
        )
        .foregroundColor(.gray)
    }
    
    var hearts: some View {
        HStack(spacing: 0) {
           ForEach(0..<maxRating, id: \.self) { _ in
               Image(systemName: "heart.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
           }
       }
    }
}
