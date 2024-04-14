//
//  Auth_CoordinatorApp.swift
//  Auth Coordinator
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

@main
struct Auth_CoordinatorApp: App {
    
    @StateObject private var appCoordinator = AppCoordinator(path: NavigationPath())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
                appCoordinator.view()
                    .navigationDestination(for: AuthCoordinator.self) { coordinator in
                        coordinator.view()
                    }
            }
            .environmentObject(appCoordinator)
            
        }
    }
}
