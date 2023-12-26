//
//  ContentView.swift
//  Grids
//
//  Created by Israel Manzo on 12/25/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        GridView(rows: 4, columns: 4) {
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("Title herer it is the test for test porpuse")
            }
            
        }
    }
}

#Preview {
    ContentView()
}

// Add count for column
// Add spacing
// Add data
struct GridView<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let content: () -> Content
    
    var body: some View {
        LazyVStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content()
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping () -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

