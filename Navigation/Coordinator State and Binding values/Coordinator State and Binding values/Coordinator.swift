//
//  Coordinator.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

enum Page: String {
    case home
    case detail
    
    var id: String {
        self.rawValue
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    @ViewBuilder
    func build(_ page: Page) -> some View {
        switch page {
            case .home:
            MainView()
        case .detail:
            Text("Detail")
        }
    }
}
