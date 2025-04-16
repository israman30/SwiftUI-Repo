//
//  AccessibilityOption.swift
//  Accesibility Components
//
//  Created by Israel Manzo on 2/12/25.
//

import SwiftUI

public enum AccessibilityOption {
    case traits([AccessibilityTraits])
    case labels(_ label: String)
    case value(_ value: String)
    case hint(_ hint: String)
    case accessibilityHidden
    case behaviour(children: AccessibilityChildBehavior)
}

// MARK: - Single use of Modifier
struct AccessibilityOptionModifier: ViewModifier {
    private let label: String?
    private let value: String?
    private let hint: String?
    private let traits: AccessibilityTraits?
    private let accessibilityHidden: Bool
    private let behaviour: AccessibilityChildBehavior?
    
    public init(options: [AccessibilityOption]) {
        var label: String? = nil
        var value: String? = nil
        var hint: String? = nil
        var combinedTraits = AccessibilityTraits()
        var traitSet = false
        var accessibilityHidden: Bool = false
        var behaviour: AccessibilityChildBehavior? = nil
        
        for option in options {
            switch option {
            case .labels(let labelValue):
                label = labelValue
            case .value(let valueValue):
                value = valueValue
            case .hint(let hintValue):
                hint = hintValue
            case .traits(let traitsValue):
                traitSet = true
                let traitsToAdd = traitsValue.reduce(AccessibilityTraits()) {$0.union($1)}
                combinedTraits.formUnion(traitsToAdd)
            case .accessibilityHidden:
                accessibilityHidden = true
            case .behaviour(let behaviourValue):
                behaviour = behaviourValue
            }
        }
        
        self.label = label
        self.value = value
        self.hint = hint
        self.traits = traitSet ? combinedTraits : nil
        self.accessibilityHidden = accessibilityHidden
        self.behaviour = behaviour
        
    }
    
    func body(content: Content) -> some View {
        content
            .modifierIf(behaviour != nil) { $0.accessibilityElement(children: behaviour!) }
            .modifierIf(traits != nil) { $0.accessibilityAddTraits(traits!) }
            .modifierIf(label != nil) { $0.accessibilityLabel(Text(label!)) }
            .modifierIf(value != nil) { $0.accessibilityValue(Text(value!)) }
            .modifierIf(hint != nil) { $0.accessibilityHint(Text(hint!)) }
            .modifierIf(accessibilityHidden) { $0.accessibilityHidden(true) }
    }
}

extension View {
    @ViewBuilder
    public func modifierIf<ModifierdContent: View>(_ condition: Bool, modifer: (Self) -> ModifierdContent) -> some View {
        if condition {
            modifer(self)
        } else {
            self
        }
    }
    
    public func accessibility(options: [AccessibilityOption]) -> some View {
        self.modifier(AccessibilityOptionModifier(options: options))
    }
}
