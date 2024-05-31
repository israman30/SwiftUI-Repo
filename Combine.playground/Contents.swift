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

// MARK: 3. Operators
/**
 Operators transform, combine, and manipulate values emitted by `publishers`.
 */
// Map: Transforms each value using a closure.
let numbers = [1, 2, 3].publisher
let subscribingNumbers = numbers.map { $0 * 2 }
    .sink { value in
        print("Double value: \(value)")
    }

// MARK: Combine Operators
/**
 Combine operators are the core building blocks that allow you to manipulate and control data flow through Combine’s publishers and subscribers.
 They let you transform, filter, merge, retry, and modify streams of data to meet your specific needs.
 */

// MARK: Merge
// Combines multiple publishers into one, interleaving their values as they arrive.
// Useful when you have separate data sources and want a unified stream.
let publisherA = [1, 2, 3].publisher
let publisherB = [3, 4, 5].publisher

let merged = publisherA.merge(with: publisherB)
let subcriberMerged = merged.sink { value in
    print("Merged value: \(value)")
}

// MARK: ZIP
// Combines two publishers by pairing their values as tuples.
// Values are only emitted when both publishers have a corresponding value.
let numberToZip = [1, 2, 3].publisher
let letters = ["A", "B", "C"].publisher

let zipped = numberToZip.zip(letters)
let subscriberZip = zipped.sink { value in
    print("Zipped pair value: \(value)")
}

// MARK: CombineLatest
// Combines multiple publishers and emits a value whenever any of them produce a new value.
// The emitted value is a tuple containing the latest values of each publisher.
let publisher1 = CurrentValueSubject<Int, Never>(0)
let publisher2 = CurrentValueSubject<String, Never>("initial value")

let combined = publisher1.combineLatest(publisher2)
let subscriberCombined = combined.sink { a, b in
    print("Latest value: \(a), \(b)")
}
// Emit new value
publisher1.send(1)
publisher2.send("update")

// MARK: SwitchToLatest
// Switches to the latest publisher when a new one arrives.
// Useful for managing publishers that can dynamically change over time, like network requests.
let publisherOfPublishers = PassthroughSubject<PassthroughSubject<String, Never>, Never>()

let subscriptorPublisher = publisherOfPublishers.switchToLatest().sink { value in
    print("Received: \(value)")
}

let firstPublisher = PassthroughSubject<String, Never>()
let secondPublisher = PassthroughSubject<String, Never>()

publisherOfPublishers.send(firstPublisher)
firstPublisher.send("First: A")

publisherOfPublishers.send(secondPublisher)
secondPublisher.send("Second: B")
firstPublisher.send("Frist: C")

// MARK: ReplaceError
// Provides a fallback value if the original publisher encounters an error.
enum SomeError: Error {
    case testError
}

let failingPublisher = Fail<Int, SomeError>(error: .testError)

let subcriberError = failingPublisher
    .replaceError(with: -1)
    .sink { value in
        print("Received value [with fallback]: \(value)")
    }

// MARK: Retry
// Retries a failed publisher up to a specified number of times before emitting an error.
let retrievePublisher = PassthroughSubject<Int, Error>()

let subscriberRetrive = retrievePublisher
    .retry(3)
    .sink { completion in
        print("Completion: \(completion)")
    } receiveValue: { value in
        print("Received value: \(value)")
    }

// Simulate retries
retrievePublisher.send(completion: .failure(URLError(.notConnectedToInternet)))
retrievePublisher.send(completion: .failure(URLError(.timedOut)))
retrievePublisher.send(42) // Eventually succeeds

// MARK: Debounce
// Emits a value only if no new values have been received within a specified timeframe.
// Useful for reducing noisy streams like user input.
let textPublisher = PassthroughSubject<String, Never>()

let subscriberTexr = textPublisher
    .debounce(for: .seconds(1), scheduler: RunLoop.main)
    .sink { value in
        print("Received debounced value: \(value)")
    }
textPublisher.send("input")
textPublisher.send("updated") // Only "Input Updated" will be emitted after a delay

// MARK: Subjects
/**
 Subjects act as both publishers and subscribers, allowing them to relay values between publishers and subscribers.
 */
// PassthroughSubject: Relays values without keeping the latest value.
let passthoughSubject = PassthroughSubject<String, Never>()

let subscribingPassthrough = passthoughSubject.sink { value in
    print("Passthrough Subject received: \(value)")
}

passthoughSubject.send("Hello World!")

// CurrentValueSubject: Stores the latest value and emits it to new subscribers.
let currentValueSubject = CurrentValueSubject<String, Never>("init")

let subcribingCurrentValueSubject = currentValueSubject.sink { value in
    print("Current Value Subject received: \(value)")
}
currentValueSubject.send("updated value")

// MARK: ---- Advanced Topics ----

// MARK: AnyCancellable
/// `AnyCancellable` is a type-erased cancellable object that manages the subscription lifecycle.
let cancellable = Just("Hello, AnyCancellable")
    .sink { value in
        print(value)
    }

// MARK: @Published
/// The `@Published` property wrapper allows properties to act as publishers, making it easier to publish property changes.
class SomeViewModel {
    @Published var text = "Init"
}

let someViewModel = SomeViewModel()
let subcribingSomeViewModel = someViewModel.$text.sink { newText in
    print("Property changed: \(newText)")
}
someViewModel.text = "updated text"

// MARK: AnyPublisher
/// `AnyPublisher` is a type-erased publisher that allows us to hide the specific publisher type.
func makePublisher() -> AnyPublisher<String, Never> {
    return Just("Any Publisher function")
        .eraseToAnyPublisher()
}

let subscribingMakePublisherFunction = makePublisher()
    .sink { value in
        print(value)
    }

// MARK: ReceiveOn vs SubscribeOn
// ReceiveOn: Specifies the thread or queue on which downstream subscribers receive values.
// SubscribeOn: Specifies the thread or queue on which the upstream publisher executes.
let publisherReceive = Just("Combine scheduling")
    .subscribe(on: DispatchQueue.main)
    .receive(on: RunLoop.main)

let subscribingPublisherReceive = publisherReceive.sink { value in
    print("Received value: \(value)")
}

// MARK: EraseToAnyPublisher
/// `eraseToAnyPublisher` converts a specific publisher type to a generic `AnyPublisher`.
let publisherErasePublisher = Just("Erase Publisher")
    .eraseToAnyPublisher()

let subcribingPublisherErasePublisher = publisherErasePublisher.sink { value in
    print("Received value: \(value)")
}
