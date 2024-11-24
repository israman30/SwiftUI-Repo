//
//  Observable_MacroApp.swift
//  Observable Macro
//
//  Created by Israel Manzo on 11/23/24.
//

import SwiftUI

@main
struct Observable_MacroApp: App {
    @State private var vm = BookViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
    }
}
