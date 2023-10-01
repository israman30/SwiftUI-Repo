//
//  PostViewModel.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import Foundation
import SwiftUI
import CoreData

enum Endpoint: String {
    case posts = "https://jsonplaceholder.typicode.com/posts"
    case users = "https://jsonplaceholder.typicode.com/users"
}

@MainActor
final class PostViewModel: ObservableObject {
    
    @Published var posts = [PostModel]()
    private var endpoint: Endpoint = .posts
    
    // MARK: - Saving Fetched JSON to Core Data
    private func saveData(context: NSManagedObjectContext) {
        posts.forEach { post in
            let entity = Post(context: context)
            entity.id = Int16(post.id)
            entity.title = post.title
            entity.body = post.body
        }
        
        do {
            try context.save()
            print("SUCCESS: JSON Object saved in Cored Data")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchRequest(context: NSManagedObjectContext) {
        guard let url = URL(string: endpoint.rawValue) else { return }
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let respose = response as! HTTPURLResponse
            if respose.statusCode == 404 {
                print("DEBUG: - API Error: No Found -")
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([PostModel].self, from: data)
                DispatchQueue.main.async {
                    self.posts = posts
                    self.saveData(context: context) /// Saving context  after decode data
                    print("DEBUG: - Saved data in CD using closures.. -")
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    // MARK: - Concurrently saving into CD and render in View
    func fetchRequestWithConcurrency(context: NSManagedObjectContext) async throws -> [PostModel] {
        guard let url = URL(string: endpoint.rawValue) else {
            fatalError("DEBUG: - Error: wrong url address -")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...3000).contains(response.statusCode) else {
            fatalError("Bad response \(response.debugDescription)")
        }
        
        do {
            let posts = try JSONDecoder().decode([PostModel].self, from: data)
            self.posts = posts
            self.saveData(context: context)
            print("DEBUG: - Saved data in CD using concurrency.. -")
        } catch {
            print(error.localizedDescription)
        }
        return posts
    }
}
