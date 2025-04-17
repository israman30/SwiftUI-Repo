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

extension Template {
    func buildComponents() -> [UIComponent] {
        return components.compactMap { component in
            switch component.type {
            case ComponentType.featuredImage.rawValue:
                return try? FeaturedImageComponent(data: component.data)
            default:
                return nil
            }
        }
    }
}

extension Dictionary {
    func decode<T: Decodable>() -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: jsonData)
    }
}
