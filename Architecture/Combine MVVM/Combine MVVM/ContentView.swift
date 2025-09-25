//
//  ContentView.swift
//  Combine MVVM
//
//  Created by Israel Manzo on 9/25/25.
//

import SwiftUI
import Combine

/** `[ View ] <----binds to----> [ ViewModel ] <----calls----> [ Model ] */

struct SomeModel {
    var text: String
}

class SomeViewModel: ObservableObject {
    @Published var someStringData: String = "Hello, world!"
    
    func manage(string data: String) {
        // Business logic goes here
        someStringData = "\(data)"
    }
}

struct ContentView: View {
    @StateObject var viewModel: SomeViewModel = .init()
    var body: some View {
        VStack {
            Text(viewModel.someStringData)
            Button("Tap here") {
                let newData = SomeModel(text: "Data mutated!")
                viewModel.manage(string: newData.text)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

class SomeViewController:UIViewController {
    var viewModel: SomeViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    lazy var someLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = .init()
    }
    
    func mutateData() {
        viewModel.$someStringData
            .sink { [weak self] value in
                self?.someLabel.text = value
            }
            .store(in: &cancellable)
    }
}
