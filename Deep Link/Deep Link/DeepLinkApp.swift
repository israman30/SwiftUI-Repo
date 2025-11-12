//
//  SceneDelegate.swift
//  Deep Link
//
//  Created by Israel Manzo on 11/11/25.
//

import SwiftUI

@main
struct DeepLinkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("Opened URL: \(url.absoluteString)")
                }
        }
    }
}
