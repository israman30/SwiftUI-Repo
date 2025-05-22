//
//  Coordinator_updatedApp.swift
//  Coordinator updated
//
//  Created by Israel Manzo on 5/21/25.
//

import SwiftUI

@main
struct Coordinator_updatedApp: App {
    let rootView: MainCoorinatorPage = .root
    var body: some Scene {
        WindowGroup {
            CoordinatorStack(rootView)
        }
    }
}
