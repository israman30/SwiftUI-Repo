//
//  Navigation.swift
//  Navigation
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI
import Combine

public protocol NavigationRoute: Hashable {
    associatedtype Content: View
    
    @ViewBuilder
    func build() -> Content
}

@MainActor
class ReusableCoordinator<Route: NavigationRoute>: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func replace(with route: Route) {
        pop()
        push(route)
    }
    
    var canPop: Bool {
        !path.isEmpty
    }
}

struct CoordinatorBuilder<Route: NavigationRoute>: View {
    @ObservedObject var coordinator: ReusableCoordinator<Route>
    let route: Route
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            route.build()
                .navigationDestination(for: Route.self) { route in
                    route.build()
                }
        }
        .environmentObject(coordinator)
    }
}
