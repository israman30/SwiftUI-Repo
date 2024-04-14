//
//  Coordinator.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

/// Create pages
enum Pages: String, Identifiable {
    case viewA
    case viewB
    case viewC
    
    var id: String {
        self.rawValue
    }
}

/// Create sheet presentation
enum Sheet: String, Identifiable {
    case display
    
    var id: String {
        self.rawValue
    }
}

/// Create fullscreen sheet presentation
enum FullScreenSheet: String, Identifiable {
    case display
    
    var id: String {
        self.rawValue
    }
}

class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenSheet: FullScreenSheet?
    
    // Add a page into the path (push navigating)
    func push(_ page: Pages) {
        path.append(page)
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(_ fullScreenSheet: FullScreenSheet) {
        self.fullScreenSheet = fullScreenSheet
    }
    
    /// Removing a view from the path
    func pop() {
        path.removeLast()
    }
    
    /// Going back to root
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Dismiss sheet
    func dismissSheet() {
        sheet = nil
    }
    
    /// Dismiss full screen sheet
    func dismissFullScreenSheet() {
        fullScreenSheet = nil
    }
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .viewA:
            ViewA()
        case .viewB:
            ViewB()
        case .viewC:
            ViewC()
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .display:
            DisplayView()
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenSheet: FullScreenSheet) -> some View {
        switch fullScreenSheet {
        case .display:
            DisplayView()
        }
    }
}
