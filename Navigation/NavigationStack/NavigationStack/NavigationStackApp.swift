//
//  NavigationStackApp.swift
//  NavigationStack
//
//  Created by Israel Manzo on 5/5/24.
//

import SwiftUI

@main
struct NavigationStackApp: App {
    @StateObject var router = Router()
    var body: some Scene {
        WindowGroup {
            CountryView()
                .environmentObject(router)
        }
    }
}
