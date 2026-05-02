//
//  ContentView.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI
import Combine

// MARK: - Mock JWT (no real signature verification)
//
// This is intentionally "JWT-shaped" for demo/learning purposes.
// In production you must verify the signature (or use a library that does),
// validate issuer/audience, and treat the token as untrusted input.

struct ContentView: View {
    @EnvironmentObject private var auth: AuthStore
    @StateObject private var vm: ViewModel
    
    init() {
        _vm = StateObject(wrappedValue: ViewModel(services: NetworkManager()))
    }
    
    var body: some View {
        Group {
            if auth.isAuthenticated {
                UsersView(vm: vm)
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthStore())
    }
}
