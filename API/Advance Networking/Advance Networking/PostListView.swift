//
//  PostListView.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/posts

struct PostListView: View {
    @StateObject var vm = MyViewModel(service: ProductNetwork())
    var body: some View {
        List(vm.posts) { item in
            Text(item.title)
        }
        .task {
            await vm.fetchPost()
        }
    }
}

#Preview {
    PostListView()
}
