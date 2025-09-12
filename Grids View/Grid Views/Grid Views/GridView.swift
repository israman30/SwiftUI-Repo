//
//  GridView.swift
//  Grid Views
//
//  Created by Israel Manzo on 11/25/24.
//

import SwiftUI

struct GridView: View {
    var body: some View {
        ScrollView {
            Grid(horizontalSpacing: 4, verticalSpacing: 4) {
                ForEach(0..<10) { row in
                    GridRow {
                        ForEach(0..<10) { column in
                            ZStack {
                                Color.purple
                                Text("row: \(row), column: \(column)")
                                    .foregroundStyle(.white)
                            }
                            .frame(height: 180)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GridView()
}
