//
//  ContentView.swift
//  Router
//
//  Created by Israel Manzo on 4/18/25.
//

import SwiftUI

enum Router {
    case home
    case login
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            Text("Home")
        case .login:
            Text("Login")
        }
    }
}

struct NavigateAction {
    typealias Action = (Router) -> Void
    let action: Action
    
    func callAsFunction(_ router: Router) {
        action(router)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button {
                
            } label: {
                Text("Login")
                    .padding(.horizontal)
            }
            .buttonStyle(.bordered)
            .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
