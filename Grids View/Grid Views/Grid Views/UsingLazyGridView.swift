//
//  UsingLazyGridView.swift
//  Grid Views
//
//  Created by Israel Manzo on 11/25/24.
//

import SwiftUI

struct UsingLazyGridView: View {
    let columns = [
        GridItem(.flexible(minimum: 40, maximum: 120), spacing: 4),
        GridItem(.flexible(minimum: 60, maximum: 240), spacing: 4),
        GridItem(.flexible(minimum: 20, maximum: 360), spacing: 4)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4, content: {
                // display 26 grid items - overflowing content will be
                // scrollable
                ForEach(0..<26) { index in
                    let qnr = index.quotientAndRemainder(dividingBy: columns.count)
                    cellContents(row: qnr.quotient, column: qnr.remainder)
                }
            })
        }
        // frame modifier tells ScrollView to take up all the space
        // in the view port
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func cellContents(row: Int, column: Int) -> some View {
        ZStack {
            Color.purple
            Text("row: \(row)\ncol: \(column)")
                .foregroundStyle(Color.white)
        }
        .frame(height: 60)
    }
}

#Preview {
    UsingLazyGridView()
}
