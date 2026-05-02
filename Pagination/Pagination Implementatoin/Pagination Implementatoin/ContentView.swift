//
//  ContentView.swift
//  Pagination Implementatoin
//
//  Created by Israel Manzo on 5/1/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = PostsViewModel(service: JSONPlaceholderPostsService())
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.posts) { post in
                    PostRow(post: post)
                        .onAppear {
                            // When the last row becomes visible, request the next page.
                            // `Task {}` keeps the view body synchronous and hands the work to async context.
                            Task {
                                await vm.loadMoreIfNeeded(currentPost: post)
                            }
                        }
                }
                
                if vm.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if !vm.hasMore, !vm.posts.isEmpty {
                    HStack {
                        Spacer()
                        Text("No more posts")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            .task {
                // Initial load is separate from pull-to-refresh.
                await vm.loadInitial()
            }
            .refreshable {
                // Pull-to-refresh resets paging and reloads page 1.
                await vm.refresh()
            }
            .overlay {
                if vm.isLoadingInitial, vm.posts.isEmpty {
                    ProgressView("Loading…")
                }
            }
            .navigationTitle("Pagination")
            .alert("Error", isPresented: Binding(
                get: { vm.errorMessage != nil },
                set: { if !$0 { vm.errorMessage = nil } }
            ), actions: {
                Button("Retry") {
                    Task { await vm.retry() }
                }
                Button("OK", role: .cancel) {
                    vm.errorMessage = nil
                }
            }, message: {
                Text(vm.errorMessage ?? "Something went wrong.")
            })
        }
    }
}

private struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.title)
                .font(.headline)
            Text(post.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
