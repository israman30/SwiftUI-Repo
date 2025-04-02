//
//  ContentView.swift
//  Pagination with Fetching
//
//  Created by Israel Manzo on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: MyViewModel = .init()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.animes) { anime in
                        AnimeCard(anime: anime)
                            .padding()
                            .task {
                                await viewModel.shouldLoadPagination(id: anime.id)
                            }
                    }
                }
            }
            .navigationTitle("Anime List")
            .task {
                await viewModel.loadAnimes()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    ContentView()
}


