//
//  UIComponent.swift
//  Express
//
//  Created by Israel Manzo on 4/17/25.
//

import SwiftUI

protocol UIComponent {
    var uniqueID: String { get }
    func render() -> AnyView
}

struct FeatureImage: UIComponent {
    
    let uiModel: FeatureImageUIModel
    
    var uniqueID: String  {
        ComponentType.featuredImage.rawValue
    }
    
    func render() -> AnyView {
        AsyncImage(url: uiModel.url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .toAnyView()
    }
}

struct FeatureImageUIModel: Decodable {
    let url: URL
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
