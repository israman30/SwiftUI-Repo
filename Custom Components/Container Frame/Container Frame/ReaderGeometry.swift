//
//  ReaderGeometry.swift
//  Container Frame
//
//  Created by Israel Manzo on 10/4/25.
//

import SwiftUI

struct ReaderGeometry: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    Rectangle()
                        .fill(.cyan)
                        .frame(width: geometry.size.width * 0.8)
                    
                    Text("Content")
                        .frame(width: min(geometry.size.width * 0.9, 400))
                }
            }
        }
        
        VStack {
            Rectangle()
                .fill(.cyan)
                .containerRelativeFrame(.horizontal) { width, _ in width * 0.8 }
            
            Text("Content")
                .containerRelativeFrame(.horizontal) { width, _ in min(width * 0.9, 400) }
        }
    }
}

#Preview {
    ReaderGeometry()
}
