//
//  GridView.swift
//  Grids
//
//  Created by Israel Manzo on 12/28/23.
//

import SwiftUI

struct GridView<Content: View>: View {
    
    let columns: Int
    let content: () -> Content
    
    var adaptiveColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columns)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns) {
                content()
            }
        }
    }
    
    init(columns: Int, @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.content = content
    }
}
