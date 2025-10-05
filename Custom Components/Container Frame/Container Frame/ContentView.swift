//
//  ContentView.swift
//  Container Frame
//
//  Created by Israel Manzo on 10/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(.cyan)
                .frame(width: 300, height: 300) // Fixed size
            
            Text("Fixed Card")
                .frame(width: 250)
                .font(.title)
            
            /**
             `- iPhone SE (375pt width): Your 300pt element takes up 80% of the screen
             `- iPhone 15 Pro Max (430pt width): Same element takes up 70%
             `- iPad Pro (1024pt width): Your element looks tiny at 29% width
             
             `Apple introduced containerRelativeFrame() to solve exactly this problem. But here's what most developers miss: it's not just about screen size.
             `- In a ScrollView: It sizes relative to the scroll area
             `- In a Modal: It sizes relative to the modal, not the full screen
             `- In a Sidebar: It sizes relative to the sidebar width
             `- In a Grid cell: It sizes relative to the cell space
             */
            
            Rectangle()
                .fill(.cyan)
                .containerRelativeFrame(.horizontal) { length, axis in
                    length * 0.8 // ✅ 80% of available width - always fits
                }
                .containerRelativeFrame(.vertical) { length, axis in
                    length * 0.25 // ✅ 25% of available height - scales perfectly
                }
            
            Text("Responsive card")
                .containerRelativeFrame(.horizontal) { width, _ in
                    min(width * 0.9, 400) // ✅ Max 400pt, but scales down
                }
                .font(.title2)
        }
    }
}

#Preview {
    ContentView()
}
