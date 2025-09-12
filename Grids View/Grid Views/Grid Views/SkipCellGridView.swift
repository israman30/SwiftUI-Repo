//
//  SkipCellGridView.swift
//  Grid Views
//
//  Created by Israel Manzo on 11/25/24.
//

import SwiftUI

struct SkipCellGridView: View {
    let colorPalette: [Color] = [.red, .green, .blue, .orange]
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(0..<4) { row in
                GridRow {
                    switch row {
                    case 0:
                        // first row contents go here
                        colorPalette[0]
                        Color.clear // in order to create empty cells we use Color.clear
                        Color.clear
                        colorPalette[0]
                    case 1:
                        // second row contents go here
                        colorPalette[1]
                        colorPalette[1]
                        // if the skipped cell is at the end no need to add Color.clear
                    case 2:
                        // third row contents go here
                        colorPalette[2]
                        colorPalette[2]
                        colorPalette[2]
                        // if the skipped cell is at the end no need to add Color.clear
                    default:
                        // last row contents go here
                        colorPalette[3]
                        colorPalette[3]
                        colorPalette[3]
                        colorPalette[3]
                    }
                }
            }
        }
    }
}

#Preview {
    SkipCellGridView()
}
