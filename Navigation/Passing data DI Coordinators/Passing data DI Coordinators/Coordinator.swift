//
//  Coordinator.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

enum Pages: Hashable {
    case main
    case detail
}

final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(_ page: Pages) {
        path.append(page)
    }
    
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .main:
            MainView()
        case .detail:
            DetailView()
        }
    }
}
