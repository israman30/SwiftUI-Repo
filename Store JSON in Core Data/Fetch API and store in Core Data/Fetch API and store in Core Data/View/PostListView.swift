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
//                                vm.fetchRequest(context: context)
                                Task {
                                    try await vm.fetchRequestWithConcurrency(context: context)
                                }
                            }
                    } else {
                        List(vm.posts, id: \.id) { post in
                            CardView(post: post)
                        }
                    }
                } else {
                    List(results) { post in
                        CardView(fetchedData: post)
                    }
                }
            }
            .navigationTitle(!results.isEmpty ? "Fetched Core Data" : "Fetched JSON")
            .toolbar {
                ToolbarItem {
                    Button {
                        self.clearPosts()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.title)
                    }
                }
            }
        }
    }
    
    private func clearPosts() {
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
        vm.posts.removeAll()
    }
}

struct CardView: View {
    var post: PostModel?
    var fetchedData: Post?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post == nil ? fetchedData!.title! : post!.title)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(Color(.label))
            Text(post == nil ? fetchedData!.body! : post!.body)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color(.lightGray))
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
