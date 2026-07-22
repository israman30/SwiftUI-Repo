//
//  ResuableCoordinator.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI
import Combine

protocol NavigationRoute: Hashable, Identifiable {
    associatedtype Content: View
    
    @ViewBuilder
    func build() -> Content
}

@MainActor
class ReusableCoordinator<Route: NavigationRoute>: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheetRoute: SheetRoute?
    @Published var coverRoute: CoverRoute?
    
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
    
    // Sheet
    func presentSheet(_ route: SheetRoute) {
        sheetRoute = route
    }
    
    func dismissSheet() {
        sheetRoute = nil
    }
    
    // Cover
    func presentCover(_ route: CoverRoute) {
        coverRoute = route
    }
    
    func dismissCover() {
        coverRoute = nil
    }
}

struct CoordinatorBuilder<Route: NavigationRoute>: View {
    @ObservedObject var coordinator: ReusableCoordinator<Route>
    let route: Route
    
    init(coordinator: ReusableCoordinator<Route>, route: Route) {
        self.coordinator = coordinator
        self.route = route
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            route.build()
                .navigationDestination(for: Route.self) { route in
                    route.build()
                }
                .sheet(item: $coordinator.sheetRoute) { sheetRoute in
                    sheetRoute.build()
                }
                .fullScreenCover(item: $coordinator.coverRoute) { coverRoute in
                    coverRoute.build()
                }
        }
        .environmentObject(coordinator)
    }
}
