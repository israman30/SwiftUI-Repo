//
//  CRUD_SwiftDataApp.swift
//  CRUD SwiftData
//
//  Created by Israel Manzo on 2/7/25.
//

import SwiftUI
import SwiftData

@main
struct CRUD_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
    
    init() {
        // Find the path where SQLite is located
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
