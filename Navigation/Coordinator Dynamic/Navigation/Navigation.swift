//
//  Navigation.swift
//  Navigation
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI
import Combine

public protocol NavigationRoute: Hashable, Identifiable {
    associatedtype Content: View
    
    @ViewBuilder
    func build() -> Content
}

@MainActor
public class ReusableCoordinator<Route: NavigationRoute>: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheetRoute: Route?
    
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
    
    // Sheet Presentation
    public func presentSheet(_ route: Route) {
        sheetRoute = route
    }
    
    public func dismissSheet() {
        sheetRoute = nil
    }
}

public struct CoordinatorBuilder<Route: NavigationRoute>: View {
    @ObservedObject var coordinator: ReusableCoordinator<Route>
    let route: Route
    
    public init(coordinator: ReusableCoordinator<Route>, route: Route) {
        self.coordinator = coordinator
        self.route = route
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            route.build()
                .navigationDestination(for: Route.self) { route in
                    route.build()
                }
        }
        .environmentObject(coordinator)
        .sheet(item: $coordinator.sheetRoute) { sheetRoute in
            NavigationStack(path: $coordinator.path) {
                sheetRoute.build()
                    .navigationDestination(for: Route.self) { route in
                        route.build()
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
