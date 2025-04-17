//
//  Template.swift
//  Express
//
//  Created by Israel Manzo on 4/17/25.
//

import Foundation

enum ComponentType: String, Decodable {
    case featuredImage
}

struct ComponentModel: Decodable {
    let type: String
    let data: [String:String]
}

struct Template: Decodable {
    let title: String
    let components: [ComponentModel]
}
