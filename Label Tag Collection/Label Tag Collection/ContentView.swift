//
//  ContentView.swift
//  Label Tag Collection
//
//  Created by Israel Manzo on 11/9/24.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var countries: [String] = []
    
    init () {
        self.countries = [
            "USA", "Canada", "Mexico", "France", "Germany", "Italy", "Spain", "UK", "Netherlands", "Sweden", "Denmark", "Ecuador", "Colombia", "Peru", "Venezuela", "Brazil", "Argentina", "Chile", "Australia", "New Zealand", "South Africa", "Zimbabwe", "Zimbabwe"
        ]
    }
}

struct ContentView: View {
    @StateObject var viewModel: ViewModel = .init()
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { country in
                    Text(country)
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter { $0.contains(searchText) }
        }
    }
}

#Preview {
    ContentView()
}


