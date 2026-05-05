//
//  ContentView.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        Group {
            switch coordinator.route {
            case .splash:
                SplashView()
            case .login:
                LoginView()
            case .signup:
                SignUpView()
            case .main:
                MainView()
            }
        }
        .environmentObject(coordinator)
        .animation(.easeInOut(duration: 0.35), value: coordinator.route)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
