//
//  ReusableCoordinatorSampleView.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI

enum AppPages: NavigationRoute {
    var id: String {
        UUID().uuidString
    }
    
    case home
    case detail(user: User)
    case settings
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine("home")
        case .detail(let user):
            hasher.combine("detail")
            hasher.combine(user.id)
        case .settings:
            hasher.combine("settings")
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
        case .settings:
            DetailSheetView()
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
        .toolbar(content: {
            Button("Present") {
                coordinator.presentSheet(.settings)
            }
        })
        .navigationTitle("Usage")
        .task {
            await vm.loadUsers()
        }
    }
}

#Preview {
    NavigationStack {
        ReusableCoordinatorSampleView()
    }.environmentObject(AppCoordinator())
}

struct DetailSheetView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        Group {
            Section(header: Text("Settings")) {
                Text("Do some settings")
            }
            Button("Dismiss page") {
                coordinator.dismissSheet()
            }
            .buttonStyle(.bordered)
        }
    }
}
