//
//  Router.swift
//  VIPER
//
//  Created by Israel Manzo on 5/31/23.
//

import Foundation
import UIKit

// Object
// Entry point

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entryPoint: EntryPoint?  { get set }
    static func start() -> AnyRouter
}

class UserRouter: AnyRouter {
    
    var entryPoint: EntryPoint?
    
    static func start() -> AnyRouter {
        // create components
        let router = UserRouter()
        
        // assign VIP
        var view: AnyView = UserViewController()
        
        var presenter: AnyPresenter = UserPresenter()
        
        var interactor: AnyInteractor = UserInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.routes = router
        presenter.view = view
        presenter.interactor = interactor
        router.entryPoint = view as? EntryPoint 
        
        return router
    }
}
