//
//  Model.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import Foundation

struct Model: Hashable, Equatable{
    var name: String
}

struct Users: Decodable, Hashable, Equatable {
    let id: Int
    let name: String
    let email: String
}
