//
//  PostViewModel.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import Foundation
import SwiftUI
import CoreData

class PostViewModel: ObservableObject {
    
    @Published var posts = [PostModel]()
    
    // MARK: - Saving Fetched JSON to Core Data
    func saveData(context: NSManagedObjectContext) {
        posts.forEach { post in
            let entity = Post(context: context)
            entity.id = Int16(post.id)
            entity.title = post.title
            entity.body = post.body
        }
        
        do {
            try context.save()
            print("Success: JSON Object saved in Cored Data")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchRequest(context: NSManagedObjectContext) {
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
                    self.saveData(context: context) /// Saving context  after decode data
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}
