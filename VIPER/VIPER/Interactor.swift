//
//  Interactor.swift
//  VIPER
//
//  Created by Israel Manzo on 5/31/23.
//

import Foundation

//https://jsonplaceholder.typicode.com/users
protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    var task: URLSessionTask!
    
    func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failingParsingURL))
                return
            }
            
            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                self?.presenter?.interactorDidFetchUsers(with: .success(entities))
            } catch {
                self?.presenter?.interactorDidFetchUsers(with: .failure(error))
            }
        }
        task.resume()
        self.task = task
    }
    
    deinit {
        task.cancel()
    }
    
    
}
