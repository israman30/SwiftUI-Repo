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
    
    func withdraw(_ amount: Double) {
        guard balance >= amount else {
            print("Insuficient balance")
            return
        }
        balance -= amount
    }
    
    func getBalance() -> Double {
        balance
    }
}
/**
 `In this example:

 `- The BankAccount actor holds a private balance variable.
 `- The deposit, withdraw, and getBalance methods provide safe access to the balance property.
 */
