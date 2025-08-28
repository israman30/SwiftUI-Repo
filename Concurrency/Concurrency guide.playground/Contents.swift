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
 `Task allows you to start asynchronous operations.
 */
