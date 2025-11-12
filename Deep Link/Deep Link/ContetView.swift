//
//  ViewController.swift
//  Deep Link
//
//  Created by Israel Manzo on 11/11/25.
//

import SwiftUI

extension URL {
    var isDeepLink: Bool {
        scheme == "deeplinkapp"
    }
    
    var selection: Selection? {
        guard isDeepLink else { return nil }
        print("URL host: \(String(describing: host))")
        switch host {
        case "home":
            return .home
        case "profile":
            return .profile
        case "books":
            return .books
        default:
            return nil
        }
    }
}

enum Selection: Hashable {
    case home
    case profile
    case books
}

struct ContentView: View {
    @State private var selection: Selection = .home
    
    var body: some View {
        TabView(selection: $selection) {
            Text("Home")
                .foregroundStyle(.blue)
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(Selection.home.hashValue)
            
            Text("Profile")
                .foregroundStyle(.red)
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(Selection.profile.hashValue)
            
            Text("Settings")
                .foregroundStyle(.cyan)
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "book")
                    Text("Books")
                }
                .tag(Selection.books.hashValue)
        }
        .onOpenURL { url in
            guard let tab = url.selection else { return }
            self.selection = tab
        }
    }
}

#Preview {
    ContentView()
}
