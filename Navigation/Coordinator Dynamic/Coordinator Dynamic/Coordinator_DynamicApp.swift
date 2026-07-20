//
//  Coordinator_DynamicApp.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/19/26.
//

import SwiftUI

@main
struct Coordinator_DynamicApp: App {
    var body: some Scene {
        WindowGroup {
//            CoordinatorView(coordinator: Coordinator())
//            AppCoordinatorView(coordinator: AppCoordinator(), route: .home)
            CoordinatorNavigation(coordinator: SampleCoordinator(), route: .home)
        }
    }
}
