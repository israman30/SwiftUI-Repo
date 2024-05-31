import UIKit
import Combine

// MARK: 1.- Publishers
/** A publisher defines a source that emits a sequence of values over time.
 Combine includes several built-in publishers like Just, `NotificationCenter.Publisher`, and many others.
 */

// Just: Emits a single value and then completes
let aPublisher = Just("Single value")
aPublisher.sink { value in
    print("Received: \(value)")
}

// NotificationCenter Publisher: Emits notifications from NotificationCenter
let notificationPublisher = NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
notificationPublisher.sink { notification in
    print("Day changed: \(notification)")
}


// MARK: 2. Subscribers
/**
 Subscribers receive values from publishers. Combine offers built-in subscribers such as `sink` and `assign`.
 */
// Sink: Handles each received value and completion event.
let aSubscriber = Just("Sink value")
    .sink { value in
        print("Received value: \(value)")
    }

// Assign: Assigns each received value to a property of an object.
class SomeClass {
    @Published var value = ""
}

let sample = SomeClass()
let subscriptor = Just("Assign Something")
    .assign(to: \.value, on: sample)

print(sample.value)
