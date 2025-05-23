//
//  ContentView.swift
//  Coordinator TabView pages
//
//  Created by Israel Manzo on 5/22/25.
//

import SwiftUI

struct VendorView: View {
    var body: some View {
        Text("Vendor View")
    }
}

struct CustomerView: View {
    var body: some View {
        Text("Customer View")
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                VendorView()
            }
            .tabItem {
                Label("Vendor", systemImage: "house")
            }
            
            NavigationStack {
                CustomerView()
            }
            .tabItem {
                Label("Customer", systemImage: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
