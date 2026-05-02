//
//  MutationState.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

/// State machine describing the lifecycle of a *write* operation (create/update/delete).
///
/// This is intentionally separate from `LoadingState`:
/// - `LoadingState` drives how a list screen renders its main content (spinner/empty/list/error).
/// - `MutationState` drives transient UI side-effects (disable buttons, show a HUD/toast/alert, etc.)
///
/// Typical usage:
/// - Set `.inProgress(operation)` before calling the service.
/// - Set `.success(operation)` after the service returns and local list state is updated.
/// - Set `.failed(operation, message)` on error (message should be display-ready).
/// - Reset back to `.idle` after the view consumes the result.
enum MutationState {
    case idle
    case inProgress(MutationOperation)
    case success(MutationOperation)
    case failed(MutationOperation, String)
}

/// The type of write action currently being performed.
enum MutationOperation {
    case create
    case update
    case delete
}
