//
//  ContentView.swift
//  Router Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
}

class Router: ObservableObject {
    
    enum Route: Hashable {
        case viewA
        case viewB
        case viewC
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder
    func view(for router: Route) -> some View {
        switch router {
        case .viewA:
            EmptyView()
        case .viewB:
            EmptyView()
        case .viewC:
            EmptyView()
        }
    }
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func goToRoot() {
        path.removeLast(path.count)
    }
}

struct RouterView<Content: View>: View {
    
    @StateObject var router = Router()
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping() -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
    }
}

struct Home: View {
    var body: some View {
        Text("Home View")
            .font(.largeTitle)
            .fontWeight(.heavy)
    }
}
