//
//  README.swift
//  MVVM to VIPER
//
//  Created by Israel Manzo on 1/26/25.
//
/**
 `What is MVVM?`
 MVVM is a design pattern that separates the UI code from the business logic. The ViewModel acts as an intermediary, holding the presentation logic, handling data binding, and processing user interactions.

 `Basic MVVM Structure:`

 - Model: Data and business logic.
 - View: UI representation.
 - ViewModel: Manages UI state, data binding, and business logic.
 */

import SwiftUI

struct User {
    let name: String
    let age: Int
}

class UserViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userAge: String = ""
    
    func loadUser() {
        let user = User(name: "John Doe", age: 25)
        userName = user.name
        userAge = "\(user.age) years old"
    }
}

struct UserView: View {
    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.userName)
            Text(viewModel.userAge)
        }.onAppear {
            viewModel.loadUser()
        }
    }
}

/**
 `What is VIPER?`
 `VIPER` is an architectural pattern that divides an app into five distinct components, each handling a specific set of responsibilities. This leads to a more modular, testable, and scalable codebase.

 `VIPER Components:`

 - `View`: Displays data and user interaction.
 - `Interactor`: Handles business logic.
 - `Presenter`: Connects the View and the Interactor, formatting data for display.
 - `Entity`: Represents the data structure.
 - `Router`: Handles navigation logic.
 */
// Entity
struct User1 {
    let name: String
    let age: Int
}

// Interactor
protocol UserInteractorProtocol {
    func fetchUser() -> User1
}
class UserInteractor: UserInteractorProtocol {
    func fetchUser() -> User1 {
        return User1(name: "Jane Doe", age: 30)
    }
}
// Presenter
protocol UserPresenterProtocol {
    func getUserName() -> String
    func getUserAge() -> String
}
class UserPresenter: UserPresenterProtocol {
    private let interactor: UserInteractorProtocol
    
    init(interactor: UserInteractorProtocol) {
        self.interactor = interactor
    }
    
    func getUserName() -> String {
        return interactor.fetchUser().name
    }
    
    func getUserAge() -> String {
        return "\(interactor.fetchUser().age) years old"
    }
}
// View
struct UserView1: View {
    var presenter: UserPresenterProtocol
    
    var body: some View {
        VStack {
            Text(presenter.getUserName())
            Text(presenter.getUserAge())
        }
    }
}
// Router
struct UserRouter {
    static func createUserModule() -> UserView1 {
        let interactor = UserInteractor()
        let presenter = UserPresenter(interactor: interactor)
        return UserView1(presenter: presenter)
    }
}
