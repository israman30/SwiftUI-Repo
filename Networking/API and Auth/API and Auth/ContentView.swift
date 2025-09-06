//
//  ContentView.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            RegisterScreen()
            AuthLoginScreen()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
