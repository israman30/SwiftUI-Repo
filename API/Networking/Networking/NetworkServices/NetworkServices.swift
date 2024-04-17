//
//  NetworkServices.swift
//  Networking
//
//  Created by Israel Manzo on 1/10/23.
//

import SwiftUI

class NetworkServices: ObservableObject {
    
    @Published var users = [User]()
    
    func fetchUser() {
        guard let url = URL(string: Constants.endopint) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                return
            }
            guard let data = data else { return }
            do {
                let jsonObject = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = jsonObject
                }
            } catch {
                print("Some error parsing json: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
