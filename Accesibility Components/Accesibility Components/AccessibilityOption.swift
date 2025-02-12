//
//  AccessibilityOption.swift
//  Accesibility Components
//
//  Created by Israel Manzo on 2/12/25.
//

import SwiftUI

enum AccessibilityOption {
    case traits([UIAccessibilityTraits])
    case labels(_ label: String)
    case value(_ value: String)
    case hint(_ hint: String)
    case accessibilityHidden
    case behaviour(_ behaviour: AccessibilityChildBehavior)
}
