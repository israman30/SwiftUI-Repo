//
//  LoadingState.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

/// A lightweight UI state machine for "load some data" screens.
///
/// Typical flow:
/// - `idle` → `loading` when a request starts
/// - `loaded(Value)` on success (or `empty` when the success payload has no items)
/// - `error(String)` when the request fails (string is display-ready)
enum LoadingState<Value: Decodable> {
    case idle
    case loading
    case empty
    case loaded(Value)
    case error(String)
}
