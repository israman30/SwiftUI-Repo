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

/// `Dictionary with Enum as the Key`
enum FontWeight {
    case regular, bold, light
}

let fontWeights: [FontWeight: CGFloat] = [
    .regular: 400,
    .bold: 700,
    .light: 300
]

/// `methods`
func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {}

/// `usage`
let launched = application(app, didFinishLaunchingWithOptions: [.url: "https://uwaisalqadri.com"])


enum RoomType {
    case bedroom, livingRoom, kitchen, bathroom
}

let roomSizes: [RoomType: Double] = [
    .bedroom: 150.0,
    .livingRoom: 200.0,
    .kitchen: 100.0,
    .bathroom: 50.0
]

/**
 `Nested Type is Fine`
  The Apple usage of the convention:
 */
struct URLRequest {
    enum CachePolicy {
        case useProtocolCachePolicy
        case reloadIgnoringLocalCacheData
        // ...
    }
    // ...
}

struct Car {
    enum EngineType {
        case gasoline, electric, hybrid
    }
    
    let engineType: EngineType
    // Other car properties...
}

/**
 `Protocol is Behavior: Find the Right Noun, Use Suffix -able If Not Found`
 */
protocol Collection { }
protocol Equatable { }
protocol Comparable: Equatable { }
protocol NSCoding {}
protocol NSSecureCoding {}
/**
 name protocols using nouns that describe the behavior or role the protocol represents.
 When a suitable noun isn’t available, they use adjectives ending in “-able” or “-ible” to describe the capability provided by the protocol, you can also describes it’s behavior using “-ing”.
 */
// Sample
protocol Vehicle {
    func move()
}

protocol Recyclable {
    func recycle()
}

struct Car: Vehicle {
    func move() {
        // Implementation...
    }
}

struct PlasticBottle: Recyclable {
    func recycle() {
        // Implementation...
    }
}

extension Car: Moving {
    func shouldMove() {
        // Implementation...
    }
}

/// `Properties` and `Constant` `variables`
let stringValue = "https://www.apple.com"
let url = URL(string: stringValue)

let imageData: Data = ...
let image = UIImage(data: imageData)


let array = [1, 2, 3]
let stringValue = array.map(String.init).joined(separator: ", ")

/**
 `Naming: From the Most Generic to the Most Specific`
 In high-level programming languages, a common naming convention is to arrange names from the most generic term to the most specific term.
 Apple applies this formula consistently across its frameworks to enhance clarity and readability. For example, in Apple’s Core frameworks, names like `URLSession` or `AVPlayerLayer` follow this principle. Here, `URL` or `AV` provides the broader context (generic), and `Session` or `PlayerLayer` represents the more specific functionality.

 Apple usage:
 */
class UIView {}
class UIButton {}
class UITableView {}
class UITableViewCell {}
class UICollectionView {}
class UICollectionViewCell {}
class UIImageView {}
class UITextField {}
class UIScrollView {}
class UIStackView {}
class UITableViewDataSource {}
class UITableViewDelegate {}
class NotificationCenter {}
class UserDefaults {}
class URLSession {}
class URLSessionTask {}
class URLSessionDataTask {}
class OperationQueue {}
class CAAnimation {}
class UIViewController {}
class AppDelegate {}
struct ContentView {}
class UIWindow {}
class UINavigationController {}
class UITabBarController {}

//This also applies to everything else:

var tableView: UITableView
var tableViewCell: UITableViewCell
var collectionView: UICollectionView
var collectionViewCell: UICollectionViewCell
var imageView: UIImageView
var textField: UITextField
var scrollView: UIScrollView
var stackView: UIStackView
var dataSource: UITableViewDataSource
var delegate: UITableViewDelegate
var fileManager: FileManager
var notificationCenter: NotificationCenter
var userDefaults: UserDefaults
var urlSession: URLSession
var urlSessionTask: URLSessionTask
var urlSessionDataTask: URLSessionDataTask
var operationQueue: OperationQueue
var animationDuration: TimeInterval
var launchScreen: UIView
var mainViewController: UIViewController
var detailViewController: UIViewController
var appDelegate: UIApplicationDelegate
var sceneDelegate: UISceneDelegate
var contentView: UIView
var profileImageView: UIImageView
var errorLabel: UILabel
var loadingSpinner: UIActivityIndicatorView
var loginButton: UIButton
var cancelButton: UIButton
var submitButton: UIButton
var primaryActionButton: UIButton
var secondaryActionButton: UIButton
var backgroundImageView: UIImageView
var placeholderTextField: UITextField
var avatarImageView: UIImageView
var headerTitleLabel: UILabel
var footerDescriptionLabel: UILabel
var defaultNotificationCenter: NotificationCenter
var defaultFileManager: FileManager
var sharedUserDefaults: UserDefaults
var mainWindow: UIWindow
var mainNavigationController: UINavigationController
var rootTabBarController: UITabBarController
var confirmationAlertController: UIAlertController
var dataLoadingErrorView: UIView
