//
//  ContentView.swift
//  Grids
//
//  Created by Israel Manzo on 12/25/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        GridView()
    }
}

#Preview {
    ContentView()
}

// Add count for column
// Add spacing
// Add data
struct GridView: View {
    
    var data = Array(1...100).map { $0 }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
    
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(data, id: \.self) { item in
                    VStack {
                        Text("Test \(item)")
                        Image(systemName: "person.fill")
                    }
                    .padding()
                }
            }
        }
        .padding(.horizontal)
    }
}

