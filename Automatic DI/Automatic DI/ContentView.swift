//
//  ContentView.swift
//  Automatic DI
//
//  Created by Israel Manzo on 4/16/25.
//

import SwiftUI

/**
 `Dependency Injection (DI)`
 Dependency injection (DI) is the most popular design pattern in term of object-oriented programming (OOP). It is a technique, that manage how an object is created, when another object depends on it. `The concept of dependency injection itself is pretty simple, there is an object depends on one or more dependencies, then the dependencies are injected into the dependent object, instead of created it inside the object.`
 */
/**
 `Automatic Dependency Injection (DI)`
 Automatic Dependency Injection (DI), basically dependency injection, but the injection process is automated. With Automatic DI developer don’t have to manually inject the dependencies, and stop worrying about where and how to inject the dependencies.
 */

// App Initialization to provide all the dependencies to app.
struct ContentView: View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("\(vm.count)")
                .font(.largeTitle)
            
            Button("Increment") {
                vm.increment()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

protocol Counter {
    func increment() -> Int
    func reset()
}

/**
 `3. Provide the dependencies.`
 Now we have the dependencies in our hand, we have to provide the dependencies so that it can be injected later. To provide the dependencies, we can create a module, and provide all the dependencies that our app uses. In this case, I only create one App Module, but you can just adjust with your app needs, let’s say if there are a lot of dependencies, you can split it into multiple module.
 */
class SingleCounter: Counter {
    private var count: Int = 0
    
    func increment() -> Int {
        count += 1
        return count
    }
    
    func reset() {
        count = 0
    }
}


struct AppModule {
    @MainActor
    static func inject() {
        @Provider var counter: Counter = SingleCounter()
    }
}

/**
 `4. Create the ViewModel.`
 Now we got everything we need, all the dependencies are provided, we can start to create the ViewModel and setup the injection.
 */
class ViewModel: ObservableObject {
    @Inject var counter: Counter
    @Published var count = 0
    
    deinit {
        DispatchQueue.main.async {
            self.counter.reset()
        }
    }
    
    func increment() {
        count = counter.increment()
    }
}
