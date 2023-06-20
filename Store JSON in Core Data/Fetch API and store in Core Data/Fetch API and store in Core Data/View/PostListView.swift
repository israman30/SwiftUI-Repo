//
//  PostListView.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject var vm = PostViewModel()
    
    var body: some View {
        VStack {
            if vm.posts.isEmpty {
                ProgressView()
            } else {
                List(vm.posts, id: \.id) { post in
                    Text(post.title)
                }
            }
        }
        .onAppear {
            vm.fetchRequest()
        }
        
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
