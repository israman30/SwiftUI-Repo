//
//  ReusableCoordinatorSampleView.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI
import Navigation

enum AppPages: NavigationRoute {
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
    
    static func == (lhs: AppPages, rhs: AppPages) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .home:
            ReusableCoordinatorSampleView()
        case .detail(let user):
            DetailView(user: user)
        }
    }
}

typealias AppCoordinator = ReusableCoordinator<AppPages>
typealias AppCoordinatorView = CoordinatorBuilder<AppPages>

struct ReusableCoordinatorSampleView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var vm = UserViewModel(network: NetworkLayer())

    var body: some View {
        List(vm.users) { user in
            Button {
                coordinator.push(.detail(user: user))
            } label: {
                DetailView(user: user)
            }
        }
        .navigationTitle("Usage")
        .task {
            await vm.loadUsers()
            log()
        }
    }
}

#Preview {
    NavigationStack {
        ReusableCoordinatorSampleView()
    }.environmentObject(AppCoordinator())
}
