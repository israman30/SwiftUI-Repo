//
//  MutationState.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

enum MutationState {
    case idle
    case inProgress(MutationOperation)
    case success(MutationOperation)
    case failed(MutationOperation, String)
}

enum MutationOperation {
    case create
    case update
    case delete
}
