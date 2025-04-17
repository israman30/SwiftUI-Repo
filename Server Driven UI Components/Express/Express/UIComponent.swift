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
    var uniqueID: String = "feature-image"
    
    func render() -> AnyView {
        AnyView(Image("feature-image"))
    }
}
