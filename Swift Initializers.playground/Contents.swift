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

/**
 `3. Required Initializers`

 `• Purpose:` Ensures all subclasses implement this initializer.

 •` Rules:`

 `• Subclasses must implement the initializer (if not inherited automatically).`
 */
// • Marked with the required keyword.
class Animal2 {
    var name: String
    
    required init(name: String) {
        self.name = name
    }
}

class Dog: Animal2 {
    required init(name: String) {
        super.init(name: name)
    }
}

/**
 `4. Failable Initializers`

 `• Purpose:` May return nil if initialization fails.

 `• Rules:`

 `• Marked with a ? or ! after init.`
 */

// • Must return nil if initialization fails.
struct Temperature {
    var celsius: Double
    
    init?(kelvin: Double) {
        guard kelvin >= 0 else { return nil }
        self.celsius = kelvin - 273.15
    }
}

/**
 `5. Convenience Failable Initializers`

 `• Combines convenience and failable features.`

 `• Rules:

 `• Must call another initializer in the same class.
 */
// • Can return nil if conditions fail.
class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    convenience init?(nickname: String?) {
        guard let validName = nickname else { return nil }
        self.init(name: validName)
    }
}

/**
 `6. Default Initializers`

 • Purpose: Automatically provided if:

 • All properties have default values.

 • No custom initializer is defined.

 • Rules:
 */
// Structs and classes with no custom initializers automatically get one.

struct Point {
    var x = 0
    var y = 0
}

let origin = Point() // Default initializer

/**
 `7. Memberwise Initializers (Structs Only)`

 `• Purpose: Automatically generated for structs if no custom initializer is defined.

 `• Rules:
 */
// Includes all properties without default values in the initializer.
struct Point1 {
    var x: Int
    var y: Int
}

let point = Point1(x: 5, y: 10) // Memberwise initializer

/**
 `8. Deinitializer (deinit)

 `• Purpose: Cleans up before an object is deallocated.

 `• Rules:

 `• Only for classes.
 */
//  No parameters or return value.
class Resource {
    deinit {
        print("Resource deallocated")
    }
}
