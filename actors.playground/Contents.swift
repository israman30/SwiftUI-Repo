import UIKit

// MARK: - What Are Actors?
// Actors are Swift’s new concurrency model that ensures your data stays thread-safe, even in the wildest multi-threaded environments. Think of them as guardians of mutable state. They control how and when code interacts with the data they manage, protecting it from being accessed simultaneously by multiple threads.

// In simple terms, actors are like a club bouncer. They ensure that only one “person” (thread) interacts with the “party” (shared data) at a time. No chaos, no drama, just order.

// MARK: - Why Use Actors?
/** Alright, let’s talk about why you should care:

- `Thread Safety
    No more worrying about those pesky race conditions. Actors ensure that your data isn’t accessed simultaneously by multiple threads.
- `Cleaner Code`
   With actors, you don’t need to sprinkle DispatchQueue calls everywhere. Your code stays tidy and readable.
- `Less Debugging`
  Since actors handle concurrency for you, you’ll spend less time tracking down weird bugs and more time building awesome features.
*/

/**
 `What Do Actors Replace?`
  Actors step in where we’d traditionally use locks, semaphores, or DispatchQueue. Say goodbye to boilerplate and hello to a more declarative way of handling concurrency. Here’s a comparison:
 */

class Counter {
    private var count = 0
    private let lock = NSLock()
    
    func increment() {
        lock.lock()
        defer {
            lock.unlock()
        }
        count += 1
    }
    
    func getValue() -> Int {
        lock.lock()
        defer {
            lock.unlock()
        }
        return count
    }
}

// Actors
actor CounterActor {
    private var count = 0
    
    func increment() {
        count += 1
    }
    
    func getValue() -> Int {
        count
    }
}
/**
 `Actors vs Singletons: A Major Upgrade`
 Here’s something exciting: actors make singletons largely unnecessary. You know the singleton pattern, right? It’s a way to ensure there’s only one instance of a class throughout your app. But, singletons have a reputation for being hard to manage in multi-threaded environments. They’re prone to race conditions and can lead to messy code.

 With actors, you get the same benefits — a single, shared instance managing state — without the headaches. An actor’s isolated state ensures that only one thread accesses its properties or methods at a time, solving the concurrency issues inherent in singletons.
 */

actor UserManager {
    private var loggedInUser = false
    
    func login() {
        loggedInUser = true
    }
    
    func logout() {
        loggedInUser = false
    }
    
    func checkUserStatus() -> Bool {
        loggedInUser
    }
}
// usage
let user = UserManager()
await user.login()
//print("Logged in: \(await user.checkUserStatus())")

actor BankAccount {
    private var balance: Double = 0
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func getBalance() -> Double {
        balance
    }
}
let account = BankAccount()
await account.deposit(100.0)
let currentBalance = await account.getBalance()
print("Balance: \(currentBalance)")


