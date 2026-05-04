//
//  RootView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct RootView: View {
    @AppStorage("jwt") private var jwt: String = ""

    var body: some View {
        Group {
            if jwt.isEmpty {
                LoginView()
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    RootView()
}

