//
//  ContentView.swift
//  Extensions
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

extension View {
    func frame(square lenght: CGFloat?, alignment: Alignment = .center) -> some View {
        self.frame(width: lenght, height: lenght, alignment: alignment)
    }
}
