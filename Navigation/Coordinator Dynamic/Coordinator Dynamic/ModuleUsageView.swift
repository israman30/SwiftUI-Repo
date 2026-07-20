//
//  ModuleUsageView.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI

struct ModuleUsageView: View {
    @StateObject var vm = UserViewModel(network: NetworkLayer())
    var body: some View {
        List(vm.users) { user in
            Button {
//                coordinator.push(.detail(user: user))
            } label: {
                DetailView(user: user)
            }
        }
        .navigationTitle("Usage")
        .task {
            await vm.loadUsers()
        }
    }
}

#Preview {
    ModuleUsageView()
}
