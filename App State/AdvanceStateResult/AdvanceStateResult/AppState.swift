//
//  AppState.swift
//  AdvanceStateResult
//
//  Created by Israel Manzo on 6/26/26.
//

import Foundation

/**
 1. Flattened Cases
 By replacing loaded(Result<Value, Error>) with top-level .loaded(Value) and .failed(Failure), switch statements become one level shallower and immediately expressive.
 2. Stale Data Retention (previous: Value?)
 Notice that both .loading and .failed accept an optional previous value. When refreshing a list of articles, calling state.startLoading() transitions the state to .loading(previous: oldArticles). Your SwiftUI view can check state.value to keep rendering the existing articles while showing a subtle top progress bar rather than a full-screen loading spinner.

 3. Conditional Conformance (where ...)
 Using conditional extensions (extension AppState: Equatable where Value: Equatable) means that if you use AppState<String, NetworkError>, it automatically becomes Equatable. If you use an un-equatable type, the enum still compiles and works without throwing generic constraint errors.

 4. Functional Transformations (map)
 If your API layer returns AppState<UserDTO>, your ViewModel can seamlessly convert it for the UI layer using state.map { UserViewModel(dto: $0) } without losing track of whether it was loading or failed.
 */

enum AppState<Value, Failure: Error> {
    case idle
    case loading(previous: Value? = nil)
    case loaded(Value)
    case failed(Failure, previous: Value? = nil)
}
// Enable Swift 6 Strict Concurrency across actor boundaries
extension AppState: Sendable where Value: Sendable, Failure: Sendable { }

// Enable SwiftUI view diffing to prevent redundant re-renders
extension AppState: Equatable where Value: Equatable, Failure: Equatable { }

// MARK: - Ergonomic Properties
/// Returns the data whether it is loaded, refreshing, or failed with stale data.
extension AppState {
    var value: Value? {
        switch self {
        case .idle:
            return nil
        case .loading(let previous):
            return previous
        case .loaded(let value):
            return value
        case .failed(_ , let previous):
            return previous
        }
    }
    
    var error: Failure? {
        if case .failed(let error, _) = self {
            return error
        }
        return nil
    }
    
    var isIdle: Bool {
        switch self {
        case .idle:
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var isLoaded: Bool {
        switch self {
        case .loaded:
            return true
        default:
            return false
        }
    }
    
    var isFailed: Bool {
        switch self {
        case .failed:
            return true
        default:
            return false
        }
    }
}

// MARK: - State Transitions & Transformations
extension AppState {
    /// Transitions the state to `.loading`, automatically preserving any existing value.
    mutating func startLoading() {
        self = .loading(previous: self.value)
    }
    
    /// Creates an AppState directly from a Swift Result.
    init(_ result: Result<Value, Failure>) {
        switch result {
        case .success(let value):
            self = .loaded(value)
        case .failure(let error):
            self = .failed(error)
        }
    }
    
    /// Transforms the underlying value while maintaining the current lifecycle state.
    func map<NewValue>(_ transform: (Value) -> NewValue) -> AppState<NewValue, Failure> {
        switch self {
        case .idle:
            return .idle
        case .loading(let previous):
            return .loading(previous: previous.map(transform))
        case .loaded(let value):
            return .loaded(transform(value))
        case .failed(let error, let previous):
            return .failed(error, previous: previous.map(transform))
        }
    }
}
