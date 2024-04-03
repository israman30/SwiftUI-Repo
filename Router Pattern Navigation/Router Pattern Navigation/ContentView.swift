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
        case viewB(String)
        case viewC
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder
    func view(for router: Route) -> some View {
        switch router {
        case .viewA:
            ViewA()
        case .viewB(let str):
            ViewB(description: str)
        case .viewC:
            ViewC()
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
        .environmentObject(router)
    }
}

struct Home: View {
    var body: some View {
        VStack {
            RouterView {
                ViewA()
            }
        }
    }
}

struct ViewA: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack() {
            Button("Go to View B") {
                router.navigate(to: .viewB("Got here from A"))
            }
            Button("Go to View C") {
                router.navigate(to: .viewC)
            }
        }
        .navigationTitle("View A")
    }
}
struct ViewB: View {
    
    @EnvironmentObject var router: Router
    
    let description: String
    
    var body: some View {
        VStack() {
            Text(description)
            Button("Go to View A") {
                router.navigate(to: .viewA)
            }
            Button("Go to View C") {
                router.navigate(to: .viewC)
            }
        }
        .navigationTitle("View B")
    }
}

struct ViewC: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack() {
            Button("Go to View B") {
                router.navigate(to: .viewB("Got here from C"))
            }
            Button("Go back") {
                router.navigateBack()
            }
        }
        .navigationTitle("View C")
    }
}
