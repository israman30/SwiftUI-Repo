//
//  ContentView.swift
//  App State (loading data)
//
//  Created by Israel Manzo on 7/16/25.
//

import SwiftUI
import Observation
 
/// UI-facing state for an async load.
///
/// `LoadingState` is designed to drive a `switch` in the view so the UI can react to each phase:
/// - `loading`: a request is in flight
/// - `empty`: the request succeeded but returned no items
/// - `loaded`: the request succeeded and produced a value (for example, an array of models)
/// - `error`: the request failed (the associated `Error` can be surfaced to the user or logged)
enum LoadingState<Value> {
    case loading
    case empty
    case error(Error)
    case loaded(Value)
}

@Observable
class StateViewModel {
    var loadingState: LoadingState<[String]> = .empty
    
    /// Loads data and updates `loadingState` to drive the UI.
    ///
    /// Expected transitions:
    /// - start: `.empty`
    /// - when loading begins: `.loading`
    /// - success: `.loaded` (or `.empty` if the result is empty)
    /// - failure: `.error`
    func fetchData() async {
        loadingState = .loading
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
