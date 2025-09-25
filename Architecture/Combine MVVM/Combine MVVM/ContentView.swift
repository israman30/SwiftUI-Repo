//
//  ContentView.swift
//  Combine MVVM
//
//  Created by Israel Manzo on 9/25/25.
//

import SwiftUI

/** `[ View ] <----binds to----> [ ViewModel ] <----calls----> [ Model ] */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
