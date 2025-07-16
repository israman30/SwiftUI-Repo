//
//  ContentView.swift
//  App State (loading data)
//
//  Created by Israel Manzo on 7/16/25.
//

import SwiftUI
import Observation

@Observable
class StateViewModel {
    var data = [String]()
    
    func fetchData() async {
        do {
            try await Task.sleep(for: .seconds(2))
            data = Array(1...100).map(\.description)
        } catch {
            print("Some error occurred: \(error)")
        }
    }
}

struct ContentView: View {
    @State private var viewModel = StateViewModel()
    
    var body: some View {
        List(viewModel.data, id: \.self) { data in
            Text("Item No: \(data)")
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    ContentView()
}
