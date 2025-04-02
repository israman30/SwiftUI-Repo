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
                    }
                }
            }
            .navigationTitle("Anime List")
            .task {
                await viewModel.loadAnimes()
            }
        }
    }
}

#Preview {
    ContentView()
}

class MyViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    
    func loadAnimes() async {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime?page=1") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if data.isEmpty {
                return
            }
            
            let decodedData = try JSONDecoder().decode(JikanMoeResponse.self, from: data)
            animes.append(contentsOf: decodedData.data)
        } catch {
            print(error)
        }
    }
}
