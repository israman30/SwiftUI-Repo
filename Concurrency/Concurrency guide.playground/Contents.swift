import UIKit

/**
 `Concurrency is an essential concept in modern app development. Mobile apps often perform multiple tasks simultaneously — fetching data from APIs, processing images, updating UI, and handling user interactions. If not managed properly, these tasks can block the main thread, leading to a poor user experience.

 `To solve this, Apple introduced the Swift Concurrency model in Swift 5.5 (iOS 15+), which brings structured concurrency using async/await, Tasks, and Actors.
 
 `- Downloading images in the background.
 `- Fetching data from a REST API while showing a loading indicator.
 `- Processing files while letting users interact with UI.
 */
/**
 `Async & Await
 The `async` and `await` keywords make asynchronous code look synchronous, improving readability.
 */

struct User: Decodable {
    let name: String
}

func fetchUserData() async throws -> User {
    let url = URL(string: "https://api.example.com/user")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

// usage
Task {
    do {
        let user = try await fetchUserData()
        print("User: \(user.name)")
    } catch {
        print("Error: \(error)")
    }
}
/**
 Here:
 `async → marks the function as asynchronous.
 `await → suspends execution until the async task completes.
 */

/**
 `Task:
 `allows you to start asynchronous operations.
 */
Task {
    try! await fetchUserData()
}
/**
 `- Runs asynchronously without blocking the main thread.
 `- Tasks can be child tasks (automatically cancelled when parent task is cancelled).
 */

/**
 `3. Task Groups:
 `Used for parallel execution of multiple tasks.
 */
await withTaskGroup(of: User.self) { group in
    group.addTask { try! await fetchUserData() } // API 1
    group.addTask { try! await fetchUserData() } // API 2
    
    for await result in group {
        print("Result: \(result)")
    }
}
// Here, both API requests run in parallel and results are collected as they finish.

/**
 `4. Actors
 `actor is a new reference type that protects its mutable state.
 `It ensures thread safety without using locks.
 */
actor Counter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        value
    }
}
let counter = Counter()
Task {
    await counter.increment()
    print(await counter.getValue())
}
// Actors ensure that only one task accesses mutable state at a time.

/**
 `Benefits of Swift Concurrency
 ✅ Cleaner, more readable code with async/await.
 ✅ Automatic thread management (no manual GCD juggling).
 ✅ Built-in error handling.
 ✅ Actors prevent race conditions.
 ✅ More maintainable and scalable for complex apps.
 */

// Example: Image Downloader with Swift Concurrency
func downloadImage(from url: String) async throws -> UIImage {
    guard let imageURL = URL(string: url) else { throw URLError(.badURL) }
    let (data, _) = try await URLSession.shared.data(from: imageURL)
    guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
    return image
}
// usage
Task {
    do {
        let image = try await downloadImage(from: "https://picsum.photos/200")
        DispatchQueue.main.async {
            imageView.image = image
        }
    } catch {
        print("Download failed: \(error)")
    }
}
