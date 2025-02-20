import UIKit

/**
 In computer programming, a naming convention is a set of rules for choosing the character sequence to be used for `identifiers` which denote `variables`, `types`, `functions`, and other entities in source code and `documentation`.
 
 source: https://en.wikipedia.org/wiki/Naming_convention_(programming)
 
 An often overlooked aspect of the design of object-oriented software libraries is the naming of `classes`, `methods`, `functions`, `constants`, and the other elements of a programmatic interface. This section discusses several of the naming conventions common to most items of a Cocoa interface.

 source: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingBasics.html
 */
/**
 - Use `PascalCase` for type and `protocol` names, and `lowerCamelCase` for everything else.
 - Name `booleans` like `isSpaceShip`, `hasSpacesuit`, `etc`. This makes it clear that they are booleans and not other types.
 */

// MARK: - Boolean
var isPagingEnabled: Bool = true
var isUserInteractionEnabled: Bool = true
var isRefreshing: Bool = false
/// Apple prefers boolean variables to clearly indicate a condition without any usage of prefix `has`, `should` or `is`.

class UISwitch: UIControl {
    func setOn(_ on: Bool, animated: Bool) { /* code */ }
}
/// As the context of `setOn`, you can see each of the following arguments in this method is a condition without prefix.

// MARK: - Object
class Door {
    var isLocked: Bool
    var isOpen: Bool
    
    init(isLoocked: Bool, isOpened: Bool) {
        self.isLocked = isLoocked
        self.isOpen = isOpened
    }
    
    func open(_ locked: Bool) {
        if locked {
            isLocked = false
        }
        isOpen = true
    }
}
