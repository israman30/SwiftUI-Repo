//
//  ContentView.swift
//  The Composable Architecture (TCA)
//
//  Created by Israel Manzo on 4/20/25.
//

import SwiftUI

/**
 `TCA introduced by Point-Free , is inspired by functional programming principles and aims to provide a structured and predictable way to build complex applications. It encourages the separation of concerns, making code more modular, easier to test, and maintainable.
 
 `Core Concepts:
 `1. State:
 - Represents the current `state` of your application.
 - It’s an immutable data structure that encapsulates all the information needed to render the UI and handle user interactions.
 
 `2. Action:
 - Represents a user interaction or a system event that can change the state.
 - It’s a simple data structure that describes what happened.
 
 `3. Reducer:
 - A pure function that takes the current state and an action as input and returns a new state.
 - It’s responsible for updating the state in response to actions.
 
` 4. Effect:
 - A side effect, like network requests, file I/O, or timers.
 - It’s often asynchronous and can trigger actions to update the state.
 
 `5. Environment:
 - A dependency container that provides external services like network clients, databases, or other dependencies to the reducer and effects.

 */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

// MARK: - TCA
struct Feature {
 let store: Store<State, Action, Environment>
}

struct State: Equatable {
 // …
}

enum Action: Equatable {
 // …
}

struct Environment {
 // …
}

let reducer = Reducer<State, Action, Environment> { state, action, environment in
 switch action {
 case .someAction:
 // Update state
 return .none
 case .someEffect:
 // Trigger an effect
 return .effect(environment.someEffect())
 }
}
