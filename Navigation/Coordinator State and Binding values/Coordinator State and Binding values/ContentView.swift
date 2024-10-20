//
//  ContentView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

enum Page: Hashable {
    case home
    case detail
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
    func buld(_ page: Page) -> some View {
        switch page {
            case .home:
            Text("Home")
        case .detail:
            Text("Detail")
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            List {
                ForEach(0..<10) { index in
                    Text("\(index)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
