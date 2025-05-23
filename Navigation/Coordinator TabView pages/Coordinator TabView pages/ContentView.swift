//
//  ContentView.swift
//  Coordinator TabView pages
//
//  Created by Israel Manzo on 5/22/25.
//

import SwiftUI
import Observation

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
    
    var tap: AppTap {
        switch self {
        case .vendor:
            return .vendor
        case .customer:
            return .customer
        }
    }
}

enum AppTap: Hashable {
    case vendor
    case customer
}

// MARK: - Coordinator
@Observable
class CoordinatorRoute {
    var routes: [AppTap:[Route]] = [:]
    
    func push(_ route: Route) {
        routes[route.tap, default: []].append(route)
    }
    
    subscript (tap: AppTap) -> [Route] {
        get { routes[tap] ?? [] }
        set { routes[tap] = newValue }
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
    @Environment(CoordinatorRoute.self) private var coordinator
    
    var body: some View {
        @Bindable var coordinator = coordinator
        TabView {
            NavigationStack(path: $coordinator[.vendor]) {
                VendorView()
            }
            .tabItem {
                Label("Vendor", systemImage: "house")
            }
            
            NavigationStack(path: $coordinator[.customer]) {
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
        .environment(CoordinatorRoute())
}
