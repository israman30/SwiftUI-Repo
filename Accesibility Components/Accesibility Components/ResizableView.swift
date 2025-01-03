//
//  ResizableView.swift
//  Accesibility Components
//
//  Created by Israel Manzo on 1/2/25.
//

import SwiftUI

struct ResizableView: View {
    var body: some View {
        List(0..<10, id: \.self) { item in
            ViewThatFits(in: .horizontal) {
                HorizontalView()
                VerticalView()
            }
        }
    }
}

#Preview {
    ResizableView()
}

struct HorizontalView: View {
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            
            Spacer()
            
            Text("More text here")
                .foregroundStyle(.secondary)
        }
    }
}

struct VerticalView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
                                
            Text("More text here")
                .foregroundStyle(.secondary)
        }
    }
}
