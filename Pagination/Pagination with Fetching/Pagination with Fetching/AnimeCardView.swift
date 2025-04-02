//
//  AnimeCardView.swift
//  Pagination with Fetching
//
//  Created by Israel Manzo on 4/2/25.
//

import SwiftUI

struct AnimeCard: View {
    let anime: Anime
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: anime.image.jpg.imageUrl)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 230)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 200, height: 200)
            }
            Text(anime.title)
                .lineLimit(1)
                .padding(.horizontal)
            Label {
                Text(String(format: "%.2f", anime.score ?? 0))
                    .fontWeight(.light)
            } icon: {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }.padding(.horizontal)
        }
    }
}


