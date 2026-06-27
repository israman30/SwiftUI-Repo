//
//  ContentView.swift
//  AdvanceStateResult
//
//  Created by Israel Manzo on 6/26/26.
//

import SwiftUI

struct User: Decodable {
    let id: Int
    let title: String
    let body: String
}

class NetworkManager {
    func fetchData() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _ ) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

@MainActor
@Observable
class UserViewModel {
    var appState: AppState<[User], Error> = .idle
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func loadData() async {
        appState.startLoading()
        
        do {
            let users = try await network.fetchData()
            appState = .loaded(users)
        } catch {
            appState = .failed(error, previous: appState.value)
        }
    }
}

struct ContentView: View {
    @State var viewModel: UserViewModel = .init(network: .init())
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.appState {
                case .idle:
                    Color.clear.task {
                        await viewModel.loadData()
                    }
                case .loading(_):
                    ProgressView("Fetching Articles...")
                        .controlSize(.large)
                case .loaded(let value):
                    List(value, id: \.id) { user in
                        Text(user.title)
                    }
                case .failed(let failure, let previous):
                    ContentUnavailableView {
                        Label("Couldn't Load News", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(failure.localizedDescription)
                    } actions: {
                        Button("Try Again") {
                            Task {
                                await viewModel.loadData()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
