//
//  ContentView.swift
//  Coordinator TabView pages
//
//  Created by Israel Manzo on 5/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Vendor View")
                .tabItem {
                    Label("Vendor", systemImage: "house")
                }
            
            Text("Customer View")
                .tabItem {
                    Label("Customer", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
