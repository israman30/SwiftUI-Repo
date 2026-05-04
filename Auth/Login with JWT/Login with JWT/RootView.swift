//
//  RootView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                ContentView(vm: viewModel)
            } else {
                LoginView(vm: viewModel)
            }
        }
        .task {
            await viewModel.refreshIfNeeded()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

