//
//  UIDesignKit.swift
//  UIDesignKit
//
//  Created by Israel Manzo on 1/25/23.
//

import Foundation
import UIKit

protocol UIDesignKit {
    func buildYellowView() -> UIView
}

public class DesignKit: UIDesignKit {
    
    public init() { }
    
    func buildYellowView() -> UIView {
        let uiView = UIView()
        uiView.backgroundColor = .yellow
        return uiView
    }
}
