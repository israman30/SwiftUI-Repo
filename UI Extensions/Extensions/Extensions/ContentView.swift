//
//  ContentView.swift
//  Extensions
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresent = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
            
            HStack {
                Text("Another view")
                    .font(.title)
                    .isHidden(isPresent)
                Toggle("", isOn: $isPresent)
            }
            
            
        }
        .padding()
        .background(Color.yellow)
    }
}

#Preview {
    ContentView()
}

extension View {
    func frame(square lenght: CGFloat?, alignment: Alignment = .center) -> some View {
        self.frame(width: lenght, height: lenght, alignment: alignment)
    }
    
    @ViewBuilder
    func isHidden(_ view: Bool) -> some View {
        switch view {
        case true:
            self.hidden()
        case false:
            self
        }
    }
}
