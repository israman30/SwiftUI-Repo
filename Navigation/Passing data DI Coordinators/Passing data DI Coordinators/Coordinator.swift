//
//  Coordinator.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

enum Pages: Hashable, Equatable {
    case main
    case detail(user: Users)
}

enum Sheet: String, CaseIterable, Identifiable {
    case sheet
    
    var id: String {
        self.rawValue
    }
}

final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    
    func push(_ page: Pages) {
        path.append(page)
    }
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .main:
            MainView()
        case .detail(let user):
            DetailView(user: user)
        }
    }
    
    @ViewBuilder
    func present(_ sheet: Sheet) -> some View {
        switch sheet {
        case .sheet:
            SheetViewSample()
        }
    }
    
    func push(sheet: Sheet) {
        path.append(sheet)
    }
}
