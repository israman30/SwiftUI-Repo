//
//  ContentView.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI
import Combine

struct Constants {
    /// Base API used by this sample.
    static var endopint = "https://jsonplaceholder.typicode.com"
}

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

struct ContentView: View {
    
    /// Owns the view model for the lifetime of this view.
    @StateObject var vm = ViewModel(NetworkServices())
    
    var body: some View {
        List {
            ForEach(vm.users) { user in
                Text(user.name)
                    .task {
                        // This runs as rows appear. When we get close to the bottom, the view model
                        // will fetch the next page (guarded against overlapping requests).
                        await vm.loadNextPageIfNeeded(currentItem: user)
                    }
            }

            if vm.hasMorePges && !vm.users.isEmpty {
                // Bottom loader row shown while there are more pages.
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .overlay {
            if vm.isLoding && vm.users.isEmpty {
                ProgressView("Loading...")
            } else if let message = vm.errorMessage, vm.users.isEmpty {
                // Empty state: show error only when we have nothing to display.
                VStack(spacing: 12) {
                    Text("Couldn’t load users")
                        .font(.headline)
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await vm.loadInitial() }
                    }
                }
                .padding()
            }
        }
        .refreshable {
            await vm.loadInitial()
        }
        .task {
            // Initial load when the view first appears.
            await vm.loadInitial()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
