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
    
    var body: some View {
        
        NavigationView {
            VStack {
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
            }
            .navigationTitle("Fetched JSON")
            .toolbar {
                ToolbarItem {
                    Button {
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
