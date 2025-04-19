//
//  ContentView.swift
//  Router
//
//  Created by Israel Manzo on 4/18/25.
//

import SwiftUI

enum Router {
    case home
    case login
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            Text("Home")
        case .login:
            Text("Login")
        }
    }
}

struct NavigateAction {
    typealias Action = (Router) -> Void
    let action: Action
    
    func callAsFunction(_ router: Router) {
        action(router)
    }
}

extension EnvironmentValues {
    @Entry var navigate = NavigateAction { _ in }
}

struct ContentView: View {
    
    @Environment(\.navigate) var navigate
    
    var body: some View {
        VStack {
            Button {
                Task {
                    try! await Task.sleep(for: .seconds(2.0))
                    navigate(.home)
                }
            } label: {
                Text("Login")
                    .padding(.horizontal)
            }
            .buttonStyle(.bordered)
            .font(.title)
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var routers = [Router]()
    NavigationStack(path: $routers) {
        ContentView()
            .navigationDestination(for: Router.self) { route in
                route.destination
            }
    }.environment(\.navigate, NavigateAction(action: { route in
        routers.append(route)
    }))
}
