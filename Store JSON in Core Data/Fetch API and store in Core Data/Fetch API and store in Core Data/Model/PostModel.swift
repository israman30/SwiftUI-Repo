//
//  PostModel.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import Foundation

struct PostModel: Decodable {
    let id: Int
    let title: String
    let body: String
}
