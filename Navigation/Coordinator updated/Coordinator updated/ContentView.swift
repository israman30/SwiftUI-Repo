//
//  ContentView.swift
//  Coordinator updated
//
//  Created by Israel Manzo on 5/21/25.
//

import SwiftUI

// MARK: - Coordinatable
typealias Coordinatable = View & Identifiable & Hashable

// MARK: - Coordinator
@Observable
class Coordinator<CoordinatorPage: Coordinatable> {
    var path = NavigationPath()
    var sheet: CoordinatorPage?
    var fullScreen: CoordinatorPage?
    
    enum PushType {
        case link
        case popToRoot
        case sheet
        case fullScreen
    }
    
    enum PopType {
        case link(_ last: Int)
        case sheet
        case fullScreen
    }
    
    func push(_ page: CoordinatorPage, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page.id)
        case .sheet:
            sheet = page
        case .fullScreen:
            fullScreen = page
        default:
            break
        }
    }
    
    func pop(_ type: PopType = .link(1)) {
        switch type {
        case .link(let last):
            guard last >= 0 else { return }
            path.removeLast(last)
        case .sheet:
            sheet = nil
        case .fullScreen:
            fullScreen = nil
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
}

// MARK: - Coordinator Stack
struct CoorinatorStack<CoordinatorPage: Coordinatable>: View {
    @State private var coordinator: Coordinator<CoordinatorPage> = .init()
    let root: CoordinatorPage
    
    init(_ root: CoordinatorPage) {
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: CoordinatorPage.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreen) { $0 }
        }
        .environment(coordinator)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
