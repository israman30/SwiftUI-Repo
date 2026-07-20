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
    case detail(user: User)
    case settings

    static func == (lhs: Pages, rhs: Pages) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
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
        case .detail(let user):
            DetailView(user: user)
        case .settings:
            EmptyView()
        }
    }
    
}

struct CoordinatorView: View {
    @StateObject var coordinator = Coordinator()
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.home)
                .navigationDestination(for: Pages.self) { page in
                    coordinator.build(page)
                }
        }.environmentObject(coordinator)
    }
}

class UserViewModel: ObservableObject {
    @Published var users = [User]()
    private let network: NetworkLayer
    
    init(network: NetworkLayer) {
        self.network = network
    }
    
    func loadUsers() async {
        do {
            users = try await network.fetchUsers()
        } catch {
            print("Something when wrong")
        }
    }
}

struct ContentView: View {
    @StateObject var vm = UserViewModel(network: NetworkLayer())
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        List(vm.users) { user in
            Button {
                coordinator.push(.detail(user: user))
            } label: {
                DetailView(user: user)
            }
        }
        .task {
            await vm.loadUsers()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Coordinator())
}

struct DetailView: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.title2)
            Text(user.email)
        }
    }
}
