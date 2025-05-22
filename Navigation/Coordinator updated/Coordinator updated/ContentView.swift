//
//  ContentView.swift
//  Coordinator updated
//
//  Created by Israel Manzo on 5/21/25.
//

import SwiftUI
import Observation

// MARK: - Coordinatable
typealias Coordinatable = View & Identifiable & Hashable

// MARK: - Coordinator
@Observable
class Coordinator<CoordinatorPage: Coordinatable> {
    var path = NavigationPath()
    var sheet: CoordinatorPage?
    var fullScreen: CoordinatorPage?
    
    enum PushType {
        case link
        case popToRoot
        case sheet
        case fullScreen
    }
    
    enum PopType {
        case link(_ last: Int)
        case sheet
        case fullScreen
    }
    
    func push(_ page: CoordinatorPage, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page.id)
        case .sheet:
            sheet = page
        case .fullScreen:
            fullScreen = page
        default:
            break
        }
    }
    
    func pop(_ type: PopType = .link(1)) {
        switch type {
        case .link(let last):
            guard last >= 0 else { return }
            path.removeLast(last)
        case .sheet:
            sheet = nil
        case .fullScreen:
            fullScreen = nil
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
}

// MARK: - Coordinator Stack
struct CoordinatorStack<CoordinatorPage: Coordinatable>: View {
    @State private var coordinator: Coordinator<CoordinatorPage> = .init()
    let root: CoordinatorPage
    
    init(_ root: CoordinatorPage) {
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: CoordinatorPage.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreen) { $0 }
        }
        .environment(coordinator)
    }
}

// MARK: - Coordinator pages
enum MainCoorinatorPage: Coordinatable {
    var id: UUID { .init() }
    
    case root
    case login(data: String)
    case signUp
    
    var body: some View {
        switch self {
        case .root:
            ContentView()
        case .login(let data):
            CoordinatorStack(LoginCoorinator.root(data: data))
        case .signUp:
            SignupView()
        }
    }
}

enum LoginCoorinator: Coordinatable {
    var id: UUID { .init() }
    
    case root(data: String)
    case forgotPasswrod
    
    var body: some View {
        switch self {
        case .root(let data):
            LoginView(data: data)
        case .forgotPasswrod:
            ForgetPasswordView()
        }
    }
}

// MARK: - Views
struct ContentView: View {
    
    @Environment(Coordinator<MainCoorinatorPage>.self) private var mainCoordinator
    
    var body: some View {
        VStack {
            Button("Sign Up") {
                mainCoordinator.push(.signUp)
            }
            
            Button("Log In") {
                mainCoordinator.push(.login(data: "Hello World"), type: .sheet)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct LoginView: View {
    @Environment(Coordinator<LoginCoorinator>.self) private var loginCoordinator
    @Environment(Coordinator<MainCoorinatorPage>.self) private var mainCoordinator
    let data: String
    
    var body: some View {
        VStack {
            Text(data)
            Button("Forgot password") {
                loginCoordinator.push(.forgotPasswrod)
            }
            
            Button("Pop") {
                mainCoordinator.pop(.sheet)
            }
             
        }
    }
}

struct ForgetPasswordView: View {
    var body: some View {
        Text("Forget password view")
    }
}

struct SignupView: View {
    var body: some View {
        Text("Signup view")
    }
}
