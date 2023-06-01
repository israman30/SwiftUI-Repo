//
//  Interactor.swift
//  VIPER
//
//  Created by Israel Manzo on 5/31/23.
//

import Foundation


protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getUsers() {
        
    }
    
    
}
