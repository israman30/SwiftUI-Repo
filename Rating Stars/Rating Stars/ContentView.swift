//
//  ContentView.swift
//  Rating Stars
//
//  Created by Israel Manzo on 12/18/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StarsView(rating: 1.5, maxRating: 5)
    }
}

#Preview {
    ContentView()
}

struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int

    var body: some View {
        stars
            .overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
    
    var stars: some View {
        HStack(spacing: 0) {
           ForEach(0..<maxRating, id: \.self) { _ in
               Image(systemName: "star.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
           }
       }
    }
}
