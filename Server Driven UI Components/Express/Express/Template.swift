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
    let type: ComponentType
    let data: [String:String]
}

struct Template: Decodable {
    let title: String
    let components: [ComponentModel]
}

extension Template {
    func buildComponents() throws -> [UIComponent] {
        var components: [UIComponent] = []
        
        for component in self.components {
            switch component.type {
            case .featuredImage:
                guard let uiModel: FeatureImageUIModel = component.data.decode() else { continue }
                components.append(FeatureImage(uiModel: uiModel))
            }
        }
        return components
    }
}

extension Dictionary {
    func decode<T: Decodable>() -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: jsonData)
    }
}
