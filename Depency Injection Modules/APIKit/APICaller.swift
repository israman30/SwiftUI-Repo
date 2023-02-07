//
//  APICaller.swift
//  APIKit
//
//  Created by Israel Manzo on 2/7/23.
//

import Foundation


public class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    public func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            
        }
        
        task.resume()
    }
}
