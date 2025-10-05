//
//  AnimationView.swift
//  Container Frame
//
//  Created by Israel Manzo on 10/4/25.
//

import SwiftUI

struct AnimationView: View {
    @State var isExpanded: Bool = false
    var body: some View {
        VStack {
            Rectangle()
                .containerRelativeFrame(.horizontal) { width, _ in
                    isExpanded ? width * 0.9 : width * 0.7
                }
                .animation(.easeInOut, value: isExpanded)
            
            Rectangle()
                .containerRelativeFrame(.horizontal) { width, _ in
                    isExpanded ? width * 0.9 : width * 0.7
                }
                .animation(.easeInOut, value: isExpanded)
            
            Image(systemName: "house.fill")
                .containerRelativeFrame(.horizontal) { width, _ in width * 0.8 }
                .containerRelativeFrame(.vertical) { height, _ in min(height * 0.4, 300) }
                .clipped()
        }
    }
}

#Preview {
    AnimationView()
}
