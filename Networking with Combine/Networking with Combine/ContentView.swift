//
//  ContentView.swift
//  Networking with Combine
//
//  Created by Israel Manzo on 1/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { item in
                    Text("\(item)")
                        .padding(5)
                        .font(.title3)
                }
                .navigationTitle("Network Combine")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
