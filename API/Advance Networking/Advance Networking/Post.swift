//
//  Post.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

/**
 "userId": 1,
 "id": 1,
 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 "body":
 */

struct Post: Codable, Identifiable, Hashable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

