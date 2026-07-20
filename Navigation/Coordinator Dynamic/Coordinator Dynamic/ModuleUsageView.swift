//
//  ModuleUsageView.swift
//  Coordinator Dynamic
//
//  Created by Israel Manzo on 7/20/26.
//

import SwiftUI
import Navigation

/**
 If `User` is a custom struct or enum you created, the easiest fix is to attach : `Equatable` directly to its definition. Swift will automatically synthesize the underlying equality check for `User` if all of its internal properties (like String or Int) are equatable.
 ```
 // 1. Explicitly conform User to Equatable
 struct User: Equatable {
     let id: UUID
     let name: String
 }

 // 2. Pages will now automatically synthesize Equatable
 enum Routes: Equatable {
     case home
     case profile(User)
 }
 ```
 // If `User` belongs to an external library or is a protocol/class where you cannot add `Equatable` directly, you must write the `==` comparison logic yourself inside an extension of `Pages`.
 or use Equatable methods
 ```
 func hash(into hasher: inout Hasher) {
     switch self {
     case .home:
         hasher.combine("home")
     case .detail(let user):
         hasher.combine("detail")
         hasher.combine(user.id)
     }
 }
 static func == (lhs: Routes, rhs: Routes) -> Bool {
     lhs.hashValue == rhs.hashValue
 }

 ```
 */

enum RoutePages: NavigationRoute {
    case home
    case detail(user: User)
    
    /**
     Must explicitly make your User type conform to the Equatable protocol
     */
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
    
    @ViewBuilder
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
