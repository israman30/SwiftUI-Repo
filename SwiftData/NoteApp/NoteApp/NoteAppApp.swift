//
//  NoteAppApp.swift
//  NoteApp
//
//  Created by Israel Manzo on 2/10/25.
//

import SwiftUI
import SwiftData

@main
struct NoteAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: NoteItem.self)
        }
    }
}
