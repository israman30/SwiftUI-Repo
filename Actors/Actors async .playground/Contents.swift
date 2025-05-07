import UIKit

/**
 `What Are Actors?
 `In Swift, actors are a reference type, similar to classes, but they come with built-in thread safety. When you use an actor to manage shared state, Swift automatically ensures that only one piece of code at a time can modify that state. This is done by isolating data within the actor, preventing race conditions and other concurrency issues.
 
 `Actors are especially helpful in multi-threaded applications where shared mutable data might be accessed simultaneously by different tasks.
 
 `Why Use Actors?
 `Traditionally, concurrent programming in Swift relied on tools like DispatchQueue or NSLock to control access to shared data. While effective, these tools can be error-prone and complex, especially when managing multiple resources. Actors simplify this by handling data isolation directly within their structure, reducing the cognitive load for developers.
 */
actor BankingApp {
    private var balance: Double = 0
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func withdraw(_ amount: Double) -> Bool {
        guard balance >= amount else {
            print("Insuficient balance")
            return false
        }
        balance -= amount
        return true
    }
    
    func getBalance() -> Double {
        balance
    }
}
/**
 `In this example:

 `- The BankAccount actor holds a private balance variable.
 `- The deposit, withdraw, and getBalance methods provide safe access to the balance property.
 
 `Using Actors Safely with Asynchronous Code
 `One important thing to note about actors is that interacting with an actor’s properties and methods may require an awaitkeyword. This is because access to the actor is controlled asynchronously to maintain safety across threads.
 */
let account = BankingApp()

Task {
    await account.deposit(100.0)
    print("Deposited 100.0. Current balance: \(await account.getBalance())")
    
    if await account.withdraw(50.0) {
        print("Withdrew 50.0. Current balance: \(await account.getBalance())")
    } else {
        print("Withdrawal failed. Current balance: \(await account.getBalance())")
    }
    let currentBalance = await account.getBalance()
    print("Current balance: \(currentBalance)")
}

/**
 `Here:

 `- We use await to access the actor’s methods, ensuring safe, asynchronous access to the actor’s properties.
 `- Task is used to create an asynchronous context where we can call await on actor methods.
 
 `Actor Isolation Rules
 When working with actors, there are specific isolation rules to be aware of:

 `1. Immutable Data: You can access immutable data (let constants) from outside the actor without await.
 `2. Async Access: To access mutable data, you must use await.
 `3. Sendable Types: Data passed into an actor must conform to the Sendable protocol, ensuring thread safety.
 */


/**
 `Actors vs. Classes
 `To understand why you’d use an actor instead of a class, consider the following example where we try to manage state with a class and DispatchQueue.
 */

class BankAccountWithClass {
    private var balance: Double = 0.0
    private let queue = DispatchQueue(label: "BankAccountQueue")
    
    func deposit(amount: Double) {
        queue.sync {
            balance += amount
        }
    }
    
    func withdraw(amount: Double) -> Bool {
        return queue.sync {
            guard balance >= amount else {
                print("Insufficient funds.")
                return false
            }
            balance -= amount
            return true
        }
    }
    
    func getBalance() -> Double {
        return queue.sync {
            return balance
        }
    }
}

/**
 `Advanced Example: Actor Isolation in a Shared Resource
 `To illustrate the advantages of actors further, consider an actor that logs user activity in an app.
 */
actor ActivityLogger {
    private var log: [String] = []
    
    func add(_ message: String) {
        log.append(message)
    }
    
    func getLogs() -> [String] {
        log
    }
}

/**
 `Now, let’s use ActivityLogger from multiple tasks:
 **/
let logger = ActivityLogger()

Task {
    await logger.add("User logged in")
}

Task {
    await logger.add("User updated profile")
}

Task {
    await logger.add("User logged out")
}

Task {
    let logs = await logger.getLogs()
    print("All logs: \(logs)")
}

/**
` Combining Actors with Structured Concurrency
 `Swift’s structured concurrency allows actors to work seamlessly with tasks and async functions. Here’s an example of how actors can handle concurrent updates safely.
 */
actor Counter {
    private var count: Int = 0
    
    func increment() {
        count += 1
    }
    
    func getCount() -> Int {
        count
    }
}

let counter = Counter()

await withTaskGroup(of: Void.self) { group in
    for _ in 0..<1000 {
        group.addTask {
            await counter.increment()
        }
    }
}
print("Count: \(await counter.getCount())")

/**
 `The code above creates a Counter actor, and using withTaskGroup, it runs 100 concurrent increments on the Counter. The Counter actor safely handles concurrent updates, guaranteeing that each increment is performed sequentially.
 */
