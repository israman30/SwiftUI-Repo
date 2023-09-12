//
//  ContentView.swift
//  await
//
//  Created by Israel Manzo on 9/12/23.
//

import SwiftUI

final class SomeManagerClass {
    
    func getSomeData() async throws -> String {
        return "Some data"
    }
}

@MainActor
final class ViewModel: ObservableObject {
    
    let someManage = SomeManagerClass()
    
    @Published private(set) var myData = "Data"
    
    private var tasks: [Task<Void, Never>] = []
    
    func callData() {
        let task = Task {
            do {
                myData = try await someManage.getSomeData()
            } catch {
                // Error handling
                print(error)
            }
        }
        tasks.append(task)
    }
    
    func cancelTask() {
        tasks.forEach { $0.cancel() }
        tasks = []
    }
}

struct ContentView: View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(vm.myData)
        }
        .padding()
        .onDisappear {
            vm.cancelTask()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
