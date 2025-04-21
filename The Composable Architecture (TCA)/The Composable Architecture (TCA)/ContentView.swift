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
/**
 `How TCA Works:
 `Initialization:
 - Create a Store instance, providing an initial state, a reducer, and an environment.
 
 `2. State Updates:
 - When a user interacts with the UI, an action is dispatched to the store.
 - The reducer processes the action and returns a new state.
 - The store updates its internal state and notifies the UI to re-render.
 
 `3. Effects:
 - Effects are triggered by the reducer and can perform asynchronous operations.
 - Once completed, they can dispatch new actions to update the state.
 
 `Benefits of TCA:
 - `Testability`: Pure functions and immutable data structures make testing easier.
 - `Readability`: Declarative style and clear separation of concerns.
 - `Maintainability`: Modular and reusable components.
 - `Predictability`: State changes are deterministic and easier to reason about.

 */

/**
 `Implementing Effects in TCA
 Effects are a crucial part of TCA, allowing you to handle asynchronous operations like network requests, database interactions, or timers. They provide a clean way to separate side effects from the core state logic.
 
 `Understanding Effects:

 `1.Triggering Effects:
 - A reducer can trigger an effect by returning an Effect value.
 - This effect is a function that takes an EffectRunner and returns a Cancellable.
 - The EffectRunner is used to execute the effect and the Cancellable can be used to cancel it if needed.

 `2. Handling Effects:
 - The store handles the execution of effects.
 - When an effect is triggered, the store passes the EffectRunner to the effect function.
 - The effect function can then use the EffectRunner to perform its asynchronous operation.
 */

enum Action: Equatable {
    case fetchData
    case fetchDataSuccess(Data)
    case fetchDataFailure(Error)
}

struct Environment {
    let networkClient: NetworkClient
}

let reducer = Reducer<State, Action, Environment> { state, action, environment in
    switch action {
    case .fetchData:
        return .effect(environment.networkClient.fetchData()
            .catchToEffect { error in .fetchDataFailure(error) }
            .map(Action.fetchDataSuccess))
    case .fetchDataSuccess(let data):
        // Update state with fetched data
        return .none
    case .fetchDataFailure(let error):
        // Handle error, e.g., show an error message
        return .none
    }
}
/**
` In this example:

 1. When the fetchData action is dispatched, the reducer triggers a network request using the networkClient from the environment.
 2. The network request is wrapped in an effect and passed to the store.
 3. The store executes the effect and, upon success or failure, dispatches the appropriate action to update the state.
 
` Key Points to Remember:
 - `Keep Effects Pure:` Effects should only perform side effects and return actions to update the state.
 - `Handle Errors Gracefully:` Use catchToEffect to handle errors and dispatch appropriate actions.
 - `Cancel Effects:` Use Cancellable to cancel ongoing effects if necessary.
 - `Test Effects:` Write unit tests for effects to ensure their correctness.
 
 `Testing TCA
 Testing is a crucial aspect of software development, and TCA’s functional and declarative nature makes it particularly well-suited for testing.

 Key Testing Strategies for TCA:

 `1. Unit Testing Reducers:
 - Test reducers in isolation to ensure they produce the correct state given a specific action and initial state.
 */
func testReducer() {
    let initialState = ...
    let action = ...
    let expectedState = ...

    let newState = reducer(initialState, action, Environment())

    XCTAssertEqual(newState, expectedState)
}
/**
 `2. Testing Effects:

 - Test effects independently to verify their behavior.
 - Simulate the `EffectRunner` and assert that the effect triggers the correct actions.
 */
func testEffect() {
    let expectation = XCTestExpectation()
    let effect = ...

    effect(EffectRunner { action in
        XCTAssertEqual(action, expectedAction)
        expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
}

/**
` Integrating TCA with SwiftUI
 TCA can be seamlessly integrated with SwiftUI to build user interfaces. Here’s a basic approach:

 `1. Create a SwiftUI View:
 - Define a SwiftUI view that observes the store’s state.
 - Use the state to render the UI.
 
 `2. Dispatch Actions:
 - Bind UI elements to actions and dispatch them when the user interacts with the UI.
 */
struct MyView: View {
    let store: Store<AppState, AppAction, AppEnvironment>

    var body: some View {
        VStack {
            Text(store.state.count)
            Button("Increment") {
                store.send(.increment)
            }
        }
    }
}
