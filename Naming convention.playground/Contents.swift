import UIKit
import SwiftUI

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

/**
 `Don’t Care About Type Name Length, Clear the Intention`
  Many debate on this, but Apple clearly does this:
 */
/// `SwiftUI`
class UICollectionViewCompositionalLayoutConfiguration {}
protocol UIViewControllerTransitioningDelegate {}
class UIDocumentBrowserViewController {}
class UIPresentationController {}
class UIAccessibilityCustomAction {}

/// `UIKit`
struct NavigationViewStyleConfiguration {}
protocol PreferenceKey {}
struct EnvironmentValues {}
struct GeometryProxy {}

/// `Foundation`
class JSONDecoder {}
struct DateComponentsFormatter {}
protocol URLSessionTaskDelegate {}
class FileManager {}

/// `CoreData`
class NSPersistentStoreCoordinator {}
class NSFetchedResultsControllerDelegate {}
class NSBatchDeleteRequest {}

/// `Core Animation`
class CAMediaTimingFunctionName {}
protocol CALayerDelegate {}

/**
 1. `Self-documentation:` The name itself provides a clear indication of what the type does or represents.
 2.` Improved code readability:` Even without looking at the implementation, developers can often understand the purpose of a type from its name.
 3. `Reduced ambiguity:` Longer, more specific names help to distinguish between similar but distinct concepts.
 */
// When applying this principle in your own code, consider the similar pattern:
struct EnvironmentFriendlyVehicleChargingStation {}
protocol UserAuthenticationServiceDelegate {}
class NetworkConnectivityMonitor {}
enum PaymentProcessingStatus {}

/**
 `Past Tense for Method, Present Tense or Verb for Closure`
  The Apple usage of that convention with code sample:
 */

/// `Methods`
func messaging(
  _ messaging: Messaging,
  didReceiveRegistrationToken fcmToken: String?
) {}

func viewDidLoad() {}

func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {}


/// `Closures`
let onValueChanged: ((Int) -> Void)? = { newValue in
    // Handle value change
}

let onReceive: (() -> Void)? = {
    // Handle download completion
}

let onComplete: (() -> Void)? = {
    // Handle tap event
}

/**
 `Apple uses past tense for method name or arguments from delegates, and present tense or a verb for closure properties, both used to describe ongoing or potential actions.`
 */

// MARK: - Object
class CoffeeMachine {
    func brewButtonTapped() {/* code */ }
    
    var onCupFilled: (() -> Void)?
}

/**
 `Avoid Directly Specifying Object, Use Enum or Static to Declare Type`
  `Apple usage:`
 */
// Instead of this:
Button("title") {}
    .buttonStyle(PlainButtonStyle())

// Apple prefers this:
Button("title") {}
    .buttonStyle(.plain)

// Another example:
// Instead of this:
Text("text")
    .foregroundColor(Color.red)

// Apple prefers this:
Text("text")
    .foregroundColor(.red)

/**
 Apple prefers to use static properties or enum cases to represent an object or customization.
 This approach makes the code more concise and readable. It also allows for better type inference and can make APIs more flexible.
 */
/// `emun`
enum CarType {
    case sedan
    case suv
    case truck
}

struct Car {
    let type: CarType
}

// Instead of this:
let myCar = Car(type: CarType.sedan)

// Apple's style would prefer this:
let sameCar = Car(type: .sedan)
/**
 This convention is particularly common in SwiftUI, where it’s used extensively for styling and configuration. It’s not limited to enums; it’s also used with static properties of structs or classes. The key is that the type can be inferred from the context, allowing for more concise code.
 **/
