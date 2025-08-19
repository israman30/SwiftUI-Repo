import UIKit
import Combine

/**
 `What is Combine?
 Combine is Apple’s reactive programming framework. It allows you to:

 - `Define publishers that emit values over time.
 - `Define subscribers that react to those values.
 - `Use operators to transform and manipulate data streams.
 Think of Combine as a pipeline:
 `Publisher → Operator(s) → Subscriber`
 
 `Core Concepts
 Before writing code, let’s break down the `4 key building blocks` of Combine:

 `1. Publisher → Emits values over time.
 `2. Subscriber → Receives and reacts to values.
 `3. Operator → Transforms or filters values between publisher and subscriber.
 `4. Cancellable → A token to stop the subscription.
 
 In the earlier parts of this series, we explored `Publishers`, `Subscribers`, and how data flows in Combine. Now, it’s time to dive into one of the most powerful aspects of Combine: Operators.

 Operators are the transformers in Combine’s pipeline. They allow you to modify, filter, combine, and handle data as it travels from `Publisher → Operator(s) → Subscriber`.
 
 `What are Operators in Combine?
 Operators are methods you apply to a Publisher to transform or react to the emitted values.

 Think of them like the functions in a data pipeline:

 A `map` operator can transform values.
 A `filter` operator can drop unwanted values.
 A `debounce` operator can control the frequency of events.
 
 `Categories of Operators
 Operators in Combine can be broadly divided into:

 `Transforming Operators` → Change the output values.
 `map`, `compactMap`, `replaceNil`, `scan`, `flatMap`.
 `Filtering Operators `→ Control which values are allowed to pass.
 `filter`, `removeDuplicates`, `dropFirst`, `prefix`.
 `Combining Operators` → Merge or zip multiple publishers.
 `merge`, `combineLatest`, `zip`, `switchToLatest`.
 `Time-Based Operators` → Handle delays and throttling.
 `delay`, `debounce`, `throttle`, `timeout`.
 `Error-Handling Operators` → Handle failures gracefully.
 `catch`, `retry`, `replaceError`.
 */
/// Example 1: Transforming with `map`
let numbers = [1, 2, 3, 4, 5, 6, 5].publisher
var cancellables: AnyCancellable?

cancellables = numbers
    .map { $0 * 10 } // transform values
    .sink { print($0) }

/// Example 2: Filtering with `filter`
cancellables = numbers
    .filter { $0 % 2 == 0 }   // only even numbers
    .sink { print($0) }

/// Example 3: Combining with `combineLatest`
let publisher1 = PassthroughSubject<String, Never>()
let publisher2 = PassthroughSubject<Int, Never>()

cancellables = publisher1
    .combineLatest(publisher2)
    .sink { print("Received: \($0), \($1)") }

publisher1.send("A")
publisher2.send(1)
publisher1.send("B")
publisher2.send(2)

/// Example 4: Time-Based with `debounce`
let searchTextPublisher = PassthroughSubject<String, Never>()

cancellables = searchTextPublisher
    .debounce(for: .seconds(1), scheduler: RunLoop.main)
    .sink { print("Searching for: \($0)") }

searchTextPublisher.send("S")
searchTextPublisher.send("Sw")
searchTextPublisher.send("Swi")
searchTextPublisher.send("Swift")

/// Example 5: Error Handling with `catch`
enum MyError: Error {
    case somethingWentWrong
}

let failingPublisher = Fail<String, MyError>(error: .somethingWentWrong)

cancellables = failingPublisher
    .catch { _ in
        Just("Fallback Value")
    }
    .sink { print($0) }


/// `More sample with Combine`
// Publisher
let publisher = Just("Hello, Combine!")
var cancellable = Set<AnyCancellable>()

// Subscriber
publisher
    .sink { value in
        print("Received value: \(value)")
    }
    .store(in: &cancellable)
/**
 `Explanation:
 `- Just("Hello, Combine!") → A publisher that emits one string.
 `- .sink { value in ... } → A subscriber that prints the value.
 `- .store(in: &cancellables) → Keeps the subscription alive.
 */
