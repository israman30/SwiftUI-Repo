//
//  ContentView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            List {
                ForEach(0..<10) { index in
                    Text("\(index)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
