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

enum Sheet: Hashable, Equatable, Identifiable {
    case infoChannel
    
    var id: String {
        UUID().uuidString
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismiss() {
        self.sheet = nil
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
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .infoChannel:
            SheetView()
        }
    }
}
