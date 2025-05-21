//
//  Coordinators_clean_archApp.swift
//  Coordinators clean arch
//
//  Created by Israel Manzo on 5/21/25.
//

import SwiftUI

@main
struct Coordinators_clean_archApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MyViewModel())
        }
    }
}
