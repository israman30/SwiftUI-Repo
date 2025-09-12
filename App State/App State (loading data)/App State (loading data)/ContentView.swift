//
//  ContentView.swift
//  App State (loading data)
//
//  Created by Israel Manzo on 7/16/25.
//

import SwiftUI
import Observation

enum LoadingState {
    case loading
    case empty
    case error(Error)
    case loaded([String])
}

@Observable
class StateViewModel {
    var loadingState: LoadingState = .empty
    
    func fetchData() async {
        do {
            try await Task.sleep(for: .seconds(2))
            let data = Array(1...100).map(\.description)
            self.loadingState = data.isEmpty ? .empty : .loaded(data)
        } catch {
            print("Some error occurred: \(error)")
            self.loadingState = .error(error)
        }
    }
}

struct ContentView: View {
    @State private var viewModel = StateViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
                Text("Loading...")
            case .empty:
                Text("No data available.")
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            case .loaded(let data):
                List(data, id: \.self) { data in
                    Text("Item No: \(data)")
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    ContentView()
}
