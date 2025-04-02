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
    
    var page: Int = 1
    var lastPageVisited: Int = -1
    
    func loadAnimes() async {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime?page=\(page)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if data.isEmpty {
                return
            }
            
            let decodedData = try JSONDecoder().decode(JikanMoeResponse.self, from: data)
            
            /// Assign the last page of the retreived data
            lastPageVisited = decodedData.pagination.lastVisiblePage
            
            animes.append(contentsOf: decodedData.data)
            
            ///Increment the page so that when the function is triggered again, it is ready to render the next page.
            page += 1
        } catch {
            print(error)
        }
    }
    
    func shouldLoadPagination(id: Int) async {
        if animes.last?.id == id && lastPageVisited >= page {
            await loadAnimes()
        }
    }
}
