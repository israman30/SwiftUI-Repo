//
//  HeaderView.swift
//  Grid Views
//
//  Created by Israel Manzo on 11/26/24.
//

import SwiftUI

struct HeaderView: View {
    // define 4 columns. The first column is reserved for labeling rows
    // the remaining 3 columns will display the actual content as before
    let columns = [
        GridItem(.fixed(60), spacing: 4),
        GridItem(.flexible(minimum: 40, maximum: 120), spacing: 4),
        GridItem(.flexible(minimum: 60, maximum: 240), spacing: 4),
        GridItem(.flexible(minimum: 20, maximum: 360), spacing: 4),
    ]
    
    // because the first column is reserved for labeling rows
    // we need to account for that in number of items per row
    let numberOfItemsPerRow = 3 // (columns.count - 1)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(0..<26) { index in
                        let qnr = index.quotientAndRemainder(dividingBy: numberOfItemsPerRow)
                        
                        // remainder of this equation will give us the column index
                        let columnIndex = qnr.remainder
                        
                        // quotient of this equation will give us the row index
                        let rowIndex = qnr.quotient
                        
                        // the first item in each row will be a Row label
                        // so we will render a simple Text when the column index is 0
                        if columnIndex == 0 {
                            Text("Row: \(rowIndex)")
                        }
                        
                        // the remaining items in each row will display the actual contents
                        cellContents(index: index)
                    }
                } header: {
                    headerView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func cellContents(index: Int) -> some View {
        ZStack {
            Color.purple
            Text("item: \(index)")
                .foregroundStyle(Color.white)
        }
        .frame(height: 60)
    }
    
    @MainActor
    var headerView: some View {
        // we are using LazyVGrid again here so that we can use the same
        // column definitions as in the main view. this way our header sizes
        // will be perfectly aligned with our columns
        LazyVGrid(columns: columns) {
            Color.clear // because we don't want to show anything in the top-left cell
            Text("Column 0")
            Text("Column 1")
            Text("Column 2")
        }
        .padding([.top, .bottom], 4)
        .background(Color(.systemBackground)) // any color you specify
    }
}

#Preview {
    HeaderView()
}
