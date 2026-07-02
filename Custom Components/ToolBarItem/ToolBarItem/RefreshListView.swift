//
//  RefreshListView.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

struct RefreshListView: View {
    @State var countrie = ["US", "Canada", "France", "Germany", "Ecuador"]
    @State var searchText = ""
    @State var isLoading = false
    
    var filterCountries: [String] {
        searchText.isEmpty ? countrie : countrie.filter {
            $0.localizedStandardContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filterCountries, id: \.self) { country in
                Text(country)
            }
            .navigationTitle("Countries")
            .toolbar {
                ToolbarItems.refreshButton(isLoading: isLoading) {
                    Task {
                        isLoading = true
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        isLoading = false
                    }
                }
                ToolBarSearchField(text: $searchText)
            }
        }
    }
}

#Preview {
    RefreshListView()
}
