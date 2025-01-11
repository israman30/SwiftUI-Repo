//
//  ContentView.swift
//  Coordinator Tree component
//
//  Created by Israel Manzo on 1/10/25.
//

import SwiftUI

/**
             `Profile coordinator -> Detail`
            `/`
 `Tab Coordinator -> Wallet Coordinator -> Wallet detail`
           ` \`
             `Item Coordinator -> Item detail`
                                  ` \`
                                     `Payment coordinator -> Select item -> Add to cart -> Buy item -> Summary`
 */

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
