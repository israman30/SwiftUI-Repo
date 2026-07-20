//
//  ModuleUsageView.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI
import Navigation

enum RoutePages: NavigationRoute {
    case home
    case detail(user: User)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine("home")
        case .detail(let user):
            hasher.combine("detail")
            hasher.combine(user.id)
        }
    }
    
    static func == (lhs: RoutePages, rhs: RoutePages) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func build() -> some View {
        switch self {
        case .home:
            ModuleUsageView()
        case .detail(let user):
            DetailView(user: user)
        }
    }
}

typealias SampleCoordinator = ReusableCoordinator<RoutePages>
typealias CoordinatorNavigation = CoordinatorBuilder<RoutePages>

struct ModuleUsageView: View {
    @EnvironmentObject var coordinator: SampleCoordinator
    @StateObject var vm = UserViewModel(network: NetworkLayer())
    var body: some View {
        List(vm.users) { user in
            Button {
                coordinator.push(.detail(user: user))
            } label: {
                DetailView(user: user)
            }
        }
        .navigationTitle("Sample Usage")
        .task {
            await vm.loadUsers()
        }
    }
}

#Preview {
    NavigationStack {
        ModuleUsageView()
    }.environmentObject(AppCoordinator())
}
