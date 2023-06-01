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

protocol AnyPresenter {
    var routes: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    var routes: AnyRouter?
    
    var interactor: AnyInteractor?
    
    var view: AnyView?
    
    func interactorDidFetchUsers(with result: Result<[User], Error>) {
        
    }
    
    
}
