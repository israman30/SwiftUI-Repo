import UIKit

// MARK: - Actors -

/**
 - `Concurrency is a core concept in modern programming, allowing multiple tasks to run simultaneously and efficiently, which is crucial for creating responsive and  high-performance applications.
 `In Swift, managing concurrency safely and effectively became much more robust with the introduction of Actors in Swift 5.5`.

 - `Actors are designed to provide a safer, more structured way to handle state in a concurrent environment, significantly reducing the risks of data races and ensuring the integrity of shared mutable state`.
 */

// Understanding Actors in Swift
/** `Actors are a reference type introduced in Swift 5.5 that provides a simple and safe way to manage mutable state in concurrent code. An actor protects its mutable state by ensuring that only one task can access that state at a time. This makes it easier to reason about the state and avoids common concurrency pitfalls like data races, where two or more threads access shared data simultaneously and cause unpredictable behavior`.
 */

// How Actors Work
/// - `Actors encapsulate state and provide methods to manipulate that state. They allow only one task to execute within them at any given time, ensuring mutual exclusion.
/// - `Unlike classes, actors manage concurrency automatically. When you call a method on an actor from a concurrent context, the method is executed in a thread-safe manner.
/// - `Internally, actors use a lightweight concurrency model based on cooperative multitasking. This means actors can suspend and resume tasks, providing better performance and responsiveness without blocking threads.

// The Problems Actors Solve
/// - `Data Races: Actors prevent data races by isolating state. Only one task at a time can access an actor’s mutable state.
/// - `Deadlocks: Actors avoid deadlocks by not blocking threads. Instead, they use asynchronous functions to allow other tasks to proceed while waiting.
/// - `Complex Synchronization: Actors eliminate the need for explicit locks and semaphores, reducing code complexity and potential errors.

// Best Practices for Using Actors
// 1. Minimize Shared State
/// - `Reduce the shared mutable state between actors to avoid bottlenecks and contention. Instead, prefer to keep state local to each actor or pass immutable copies of data when possible.
/// - `Example: Use immutable structures or pass-by-value parameters when interacting between actors.

// 2. Design Actor Hierarchies Carefully
/// - `Avoid nesting actor calls or creating dependencies between actors that could lead to deadlocks or starvation. A clear, well-defined actor hierarchy minimizes these risks.

// Use MainActor for UI Updates
/// - `In SwiftUI applications, UI updates should occur on the main thread. Use the @MainActor attribute to ensure actor methods that interact with UI run on the main thread.

//Example:
@MainActor
class ViewModel: ObservableObject {
    @Published var text: String = "Initial text"

    func updateText(newText: String) {
        self.text = newText
    }
}
