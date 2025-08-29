//
//  ContentView.swift
//  Segmented Control
//
//  Created by Israel Manzo on 8/29/25.
//

import SwiftUI

enum Segment: String, CaseIterable, Identifiable {
    case swift
    case uikit
    case swiftUI
    
    var id: String { self.rawValue}
}

struct ContentView: View {
    @State private var selectedSegment: Segment = .swift
    @Namespace var nameSpace
    
    var body: some View {
        HStack {
            ForEach(Segment.allCases, id: \.id) { segment in
                Button {
                    withAnimation(.easeInOut) {
                        selectedSegment = segment
                    }
                } label: {
                    Text(segment.rawValue.capitalized)
                        .bold()
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity)
                        .padding(15)
                }
                .matchedGeometryEffect(id: segment.id, in: nameSpace)
                .padding(2)
            }
        }
        .background {
            Capsule(style: .continuous)
                .matchedGeometryEffect(id: selectedSegment.id, in: nameSpace, isSource: false)
                .foregroundStyle(Color.blue.gradient)
                .shadow(color: .black.opacity(0.2), radius: 2)
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(Capsule())
    }
}

#Preview {
    ContentView()
}
