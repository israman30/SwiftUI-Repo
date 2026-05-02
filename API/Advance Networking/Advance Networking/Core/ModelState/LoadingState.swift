//
//  LoadingState.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

enum LoadingState<Value: Decodable> {
    case idle
    case loading
    case empty
    case loaded(Value)
    case error(String)
}
