//
//  AppCoordinator.swift
//  Auth Coordinator
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    
    @Published var path: NavigationPath
    
    init(path: NavigationPath) {
        self.path = path
    }
    
    @ViewBuilder
    func view() -> some View {
        MainView()
    }
}
