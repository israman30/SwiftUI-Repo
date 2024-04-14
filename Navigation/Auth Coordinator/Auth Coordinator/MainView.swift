//
//  MainView.swift
//  Auth Coordinator
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        Group {
            AuthCoordinator(
                page: .login,
                navigationPath: $appCoordinator.path,
                output: .init(
                    goToMain: {
                        print("Go to Main Screen (MainTabView)")
                    }
                )
            ).view()
        }
    }
}

#Preview {
    MainView()
}
