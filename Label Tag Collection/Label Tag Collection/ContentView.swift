//
//  ContentView.swift
//  Label Tag Collection
//
//  Created by Israel Manzo on 11/9/24.
//

import SwiftUI

struct Country: Identifiable {
    let name: String
    
    var id: String { name }
}

class ViewModel: ObservableObject {
    @Published var countries: [Country] = []
    
    init () {
        self.countries = [
            Country(name: "USA"), Country(name: "Canada"), Country(name: "Mexico"), Country(name: "El Salvador"), Country(name: "Guatemala"), Country(name: "Nicaragua"), Country(name: "Costa Rica"), Country(name: "Panama"), Country(name: "Colombia"), Country(name: "Venezuela"), Country(name: "Ecuador"), Country(name: "Peru"), Country(name: "Chile"), Country(name: "Argentina"), Country(name: "Brasil"), Country(name: "Bolivia"), Country(name: "Paraguay")
        ]
    }
}

struct ContentView: View {
    @StateObject var viewModel: ViewModel = .init()
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { country in
                    Text(country.name)
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [Country] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter { $0.name.contains(searchText) }
        }
    }
    
    private var countryTag: some View {
        TagCollectionView(data: viewModel.countries) { country in
            
        }
    }
}

#Preview {
    ContentView()
}

