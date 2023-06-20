//
//  PostListView.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject var vm = PostViewModel()
    @Environment(\.managedObjectContext) var context
    
    // MARK: - Fetching data from Core Data
    @FetchRequest(entity: Post.entity(), sortDescriptors: []) var results: FetchedResults<Post>
    
    var body: some View {
        
        NavigationView {
            VStack {
                // IF CORE DATA HAS OBJECT
                if results.isEmpty {
                    if vm.posts.isEmpty {
                        ProgressView()
                            .onAppear {
                                vm.fetchRequest(context: context)
                            }
                    } else {
                        List(vm.posts, id: \.id) { post in
                            Text(post.title)
                        }
                    }
                } else {
                    List(results) { post in
                        Text(post.title ?? "No Title")
                    }
                }
                
            }
            .navigationTitle(!results.isEmpty ? "Fetched Core Data" : "Fetched JSON")
            .toolbar {
                ToolbarItem {
                    Button {
                        /// Clear  Core Data
                        do {
                            results.forEach { post in
                                context.delete(post)
                            }
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        /// Clrea array Posts it will fetch again
                        self.vm.posts.removeAll()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.title)
                    }

                }
            }
        }
        
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
