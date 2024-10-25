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
    case secondPage
    
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
    case infoChannel(_ userActivity: Binding<Bool>)
    
    var id: String {
        UUID().uuidString
    }
    
    static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .infoChannel(let userActivity):
            hasher.combine(userActivity.wrappedValue)
        }
    }
}

enum FullScreen: Hashable, Equatable, Identifiable {
    case fullScreen
    
    var id: String {
        UUID().uuidString
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreen: FullScreen?
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFull(_ screen: FullScreen) {
        self.fullScreen = screen
    }
    
    func dismiss() {
        self.sheet = nil
    }
    
    func dismissFullScren() {
        self.fullScreen = nil
    }
    
    @ViewBuilder
    func build(_ page: Page, myViewModel: MyViewModel) -> some View {
        switch page {
        case .home:
            MainView()
        case .detail:
            DetailView()
        case .user(let isUserLoggedIn):
            UserView(isUserLoggedIn: isUserLoggedIn, myViewModel: myViewModel)
        case .secondPage:
            SecondPageView()
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet, myViewModel: MyViewModel) -> some View {
        switch sheet {
        case .infoChannel:
            SheetView(myViewModel: myViewModel)
        }
    }
    
    @ViewBuilder
    func build(fullScreen: FullScreen, myViewModel: MyViewModel) -> some View {
        switch fullScreen {
        case .fullScreen:
            FullScreenView()
        }
    }
}
