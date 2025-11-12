//
//  ViewController.swift
//  Deep Link
//
//  Created by Israel Manzo on 11/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Home")
                .foregroundStyle(.blue)
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Text("Profile")
                .foregroundStyle(.red)
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            
            Text("Settings")
                .foregroundStyle(.cyan)
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "book")
                    Text("Books")
                }
        }
    }
}

#Preview {
    ContentView()
}
