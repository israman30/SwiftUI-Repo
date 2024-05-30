import UIKit
import Combine

// MARK: 1.- Publishers
/** A publisher defines a source that emits a sequence of values over time.
 Combine includes several built-in publishers like Just, `NotificationCenter.Publisher`, and many others.
 */

let aPublisher = Just("Single value")
aPublisher.sink { value in
    print("Received: \(value)")
}
