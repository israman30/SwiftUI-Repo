//
//  PostViewModel.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import Foundation
import SwiftUI

class PostViewModel: ObservableObject {
    
    @Published var posts = [PostModel]()
    
    func fetchRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let respose = response as! HTTPURLResponse
            if respose.statusCode == 404 {
                print("API No Found")
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([PostModel].self, from: data)
                DispatchQueue.main.async {
                    self.posts = posts
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}
