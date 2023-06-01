//
//  Presenter.swift
//  VIPER
//
//  Created by Israel Manzo on 5/31/23.
//

import Foundation

// Object
// protocol
// reference to interactor, router, view

enum FetchError: Error {
    case failingParsingURL
}

protocol AnyPresenter {
    var routes: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    var routes: AnyRouter?
    
    var interactor: AnyInteractor? {
        didSet {
            self.interactor?.getUsers()
        }
    }
    
    var view: AnyView?
    
    func interactorDidFetchUsers(with result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            view?.update(with: users)
        case .failure:
            view?.update(with: "something went wrong")
        }
    }
    
    
}
