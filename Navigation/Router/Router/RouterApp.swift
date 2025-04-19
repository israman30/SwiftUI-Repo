//
//  RouterApp.swift
//  Router
//
//  Created by Israel Manzo on 4/18/25.
//

import SwiftUI

@main
struct RouterApp: App {
    @State var routers = [Router]()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routers) {
                ContentView()
                    .navigationDestination(for: Router.self) { route in
                        route.destination
                    }
            }.environment(\.navigate, NavigateAction(action: { route in
                routers.append(route)
            }))
        }
    }
}
