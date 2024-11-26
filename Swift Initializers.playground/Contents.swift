import UIKit

/**
 `1. Designated Initializers`

 `• Purpose:` The primary initializer for a class. It initializes all properties of the class.

 `• Rules:`

 `• Must initialize all stored properties of the current class.`
 */

// Calls a designated initializer of the superclass (for classes).

/**
` init(parameters) {
    // Initialize properties
 `}`
 */

class Animal {
    var name: String
    init(name: String) {
        self.name = name
    }
}

/**
 `2. Convenience Initializers`

 `• Purpose:` Secondary initializers for a class that provide shortcuts or default setups.

 `• Rules:`

    `• Must call another initializer in the same class (either a designated or another convenience initializer).`
 */

// Cannot directly initialize stored properties.
/**
 `convenience init(parameters) {
     self.init(otherParameters)
 `}`
 */
class Animal1 {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "Unknown")
    }
}
