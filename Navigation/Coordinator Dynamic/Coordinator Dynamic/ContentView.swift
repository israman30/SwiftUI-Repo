//
//  ContentView.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/19/26.
//

import SwiftUI
import  Combine

enum Pages: Hashable {
    case home
    case detail(id: String, title: String, description: String)
    case settings
}

@MainActor
class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ page: Pages) {
        path.append(page)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .home:
            ContentView()
        case .detail(let id, let title, let description):
            DetailView(id: id, title: title, description: description)
        case .settings:
            EmptyView()
        }
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

struct DetailView: View {
    let id: String
    let title: String
    let description: String
    var body: some View {
        VStack {
            Text("id: \(id) - \(title)")
            Text(title)
            Text(description)
        }
    }
}
