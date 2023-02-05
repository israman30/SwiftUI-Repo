import UIKit

let shareSession = URLSession.shared
shareSession.configuration.allowsCellularAccess
shareSession.configuration.allowsCellularAccess = false
shareSession.configuration.allowsCellularAccess

let myDefaultConfiguration = URLSessionConfiguration.default
let eConfig = URLSessionConfiguration.ephemeral
let bConfig = URLSessionConfiguration.background(withIdentifier: "com.israel.com.session")

myDefaultConfiguration.allowsCellularAccess = false
myDefaultConfiguration.allowsCellularAccess

myDefaultConfiguration.allowsExpensiveNetworkAccess = true
myDefaultConfiguration.allowsConstrainedNetworkAccess = true

let myDefaultSession = URLSession(configuration: myDefaultConfiguration)
myDefaultSession.configuration.allowsConstrainedNetworkAccess

let defaultSession = URLSession(configuration: .default)
defaultSession.configuration.allowsCellularAccess
