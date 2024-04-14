//
//  ContentView.swift
//  Alignments
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .background(Color.yellow)
    }
}

#Preview {
    ContentView()
}

enum CustomAlignment {
    case top
    case leading
    case trailing
    case bottom
    case center
}

extension View {
    
    @ViewBuilder
    func alignment(at alignment: CustomAlignment) -> some View {
        switch alignment {
        case .top:
            self.frame(maxHeight: .infinity, alignment: .top)
        case .bottom:
            self.frame(maxHeight: .infinity, alignment: .bottom)
        case .leading:
            self.frame(maxWidth: .infinity, alignment: .leading)
        case .trailing:
            self.frame(maxWidth: .infinity, alignment: .trailing)
        case .center:
            self.frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
