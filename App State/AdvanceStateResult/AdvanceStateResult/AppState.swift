//
//  AppState.swift
//  AdvanceStateResult
//
//  Created by Israel Manzo on 6/26/26.
//

import Foundation

enum AppState<Value, Failure: Error> {
    case idle
    case lodaing(previous: Value? = nil)
    case loaded(Value)
    case failed(Failure, previous: Value? = nil)
}
// Enable Swift 6 Strict Concurrency across actor boundaries
extension AppState: Sendable where Value: Sendable, Failure: Sendable { }

// Enable SwiftUI view diffing to prevent redundant re-renders
extension AppState: Equatable where Value: Equatable, Failure: Equatable { }

/// Returns the data whether it is loaded, refreshing, or failed with stale data.
extension AppState {
    var value: Value? {
        switch self {
        case .idle:
            return nil
        case .lodaing(let previous):
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
        case .lodaing:
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
