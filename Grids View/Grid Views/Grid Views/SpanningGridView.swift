//
//  SpanningGridView.swift
//  Grid Views
//
//  Created by Israel Manzo on 11/25/24.
//

import SwiftUI

struct SpanningGridView: View {
    let colorPalette: [Color] = [.red, .green, .blue, .orange]
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(0..<4, id: \.self) { row in
                GridRow {
                    switch row {
                    case 0:
                        colorPalette[0]
                            .gridCellColumns(4) // this cell will be 4-columns-wide
                    case 1:
                        colorPalette[1]
                        colorPalette[1]
                            .gridCellColumns(3) // this cell will be 3-columns-wide
                    case 2:
                        colorPalette[2]
                        colorPalette[2]
                        colorPalette[2]
                            .gridCellColumns(2) // this cell will be 2-columns-wide
                    default:
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
    SpanningGridView()
}
