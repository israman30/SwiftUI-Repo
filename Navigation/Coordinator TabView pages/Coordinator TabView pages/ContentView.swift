//
//  ContentView.swift
//  Coordinator TabView pages
//
//  Created by Israel Manzo on 5/22/25.
//

import SwiftUI

// MARK: - Model
struct Vendor: Hashable {
    let name: String
}

// MARK: - Routes
enum VendorRoutes: Hashable {
    case list
    case create
    case detail(Vendor)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .list:
            Text("Vendor List")
        case .create:
            Text("Create Vendor")
        case .detail(let vendor):
            Text("Detail of \(vendor.name)")
        }
    }
}

enum CusomterRoutes: Hashable {
    case list
    case create
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .list:
            Text("List")
        case .create:
            Text("Create")
        }
    }
}

enum Route: Hashable {
    case vendor(VendorRoutes)
    case customer(CusomterRoutes)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .vendor(let vendorRoutes):
            vendorRoutes.destination
        case .customer(let customerRoutes):
            customerRoutes.destination
        }
    }
}


// MARK: - Views
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
