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
public class ReusableCoordinator<Route: NavigationRoute>: ObservableObject {
    @Published var path = NavigationPath()
    
    public func push(_ route: Route) {
        path.append(route)
    }
    
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    public func replace(with route: Route) {
        pop()
        push(route)
    }
    
    public var canPop: Bool {
        !path.isEmpty
    }
}

public struct CoordinatorBuilder<Route: NavigationRoute>: View {
    @ObservedObject var coordinator: ReusableCoordinator<Route>
    let route: Route
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            route.build()
                .navigationDestination(for: Route.self) { route in
                    route.build()
                }
        }
        .environmentObject(coordinator)
    }
}
