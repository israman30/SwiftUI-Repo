//
//  Coordinator.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

enum Page: Hashable, Equatable {
    case home
    case detail
    case user(_ isUserLoggedIn: Binding<Bool>)
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .user(let isUserLoggedIn):
            hasher.combine(isUserLoggedIn.wrappedValue)
        default:
            break
        }
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
            DetailView()
        case .user(let isUserLoggedIn):
            UserView(isUserLoggedIn: isUserLoggedIn)
        }
    }
}
