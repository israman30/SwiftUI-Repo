//
//  Coordinator_TabView_pagesApp.swift
//  Coordinator TabView pages
//
//  Created by Israel Manzo on 5/22/25.
//

import SwiftUI

@main
struct Coordinator_TabView_pagesApp: App {
    @State var coordinator = CoordinatorRoute()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.coordinator, coordinator)
        }
    }
}
