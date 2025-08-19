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


/**
 `What is a Subscriber?
 A `subscriber` is responsible for:

 `1. Receiving values from a publisher.
 `2. Handling completion events (success or failure).
 `3. Controlling how much demand it has for values.
 
 Formally, a subscriber conforms to the Subscriber protocol:
 ```
 protocol Subscriber {
     associatedtype Input
     associatedtype Failure: Error
     
     func receive(subscription: Subscription)
     func receive(_ input: Input) -> Subscribers.Demand
     func receive(completion: Subscribers.Completion<Failure>)
 }
 ```
 */

/**
 `Built-in Subscribers
 `1. sink
 The most commonly used subscriber.
 It lets you provide two closures:

 `- One for handling values.
 `- One for handling completion.
 */
numbers.sink(
    receiveCompletion: { completion in
        print("Completed with: \(completion)")
    },
    receiveValue: { value in
        print("Received value: \(value)")
    }
)
.store(in: &cancellable)

/**
 `Demand and Backpressure
 One unique aspect of Combine is `backpressure handling`.
 Subscribers can control how many values they want to receive at a time, using `demand`.

 For example, if you implement a custom subscriber:
 */
final class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        print("Subscribed!")
        subscription.request(.max(2)) // Request only 2 values
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received \(input)")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}

let newPublisher = [10, 20, 30, 40, 50].publisher
let subscriber = IntSubscriber()

newPublisher.subscribe(subscriber)
