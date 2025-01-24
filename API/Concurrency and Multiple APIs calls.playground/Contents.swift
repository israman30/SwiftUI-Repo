import UIKit
import Combine

//MARK: - 1. Using DispatchGroup
// DispatchGroup is a core part of Grand Central Dispatch (GCD) and is ideal for managing multiple asynchronous tasks.
/**
 - `Pros:
   - Simple and effective for most use cases.
   - Allows monitoring the completion of all tasks.
 - `Cons:
   -  Managing large-scale operations can be tricky.
   - Error handling and individual task cancellation are cumbersome.
 */

func fecthData() {
    let group = DispatchGroup()
    
    let urls: [URL] = [
        URL(string: "https://jsonplaceholder.typicode.com/todos/1")!,
        URL(string: "https://jsonplaceholder.typicode.com/todos/2")!,
        URL(string: "https://jsonplaceholder.typicode.com/todos/3")!
    ]
    
    var results: [Data?] = []
    
    for (index, url) in urls.enumerated() {
        group.enter()
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            results[index] = data
            group.leave()
        }.resume()
    }
    
    group.notify(queue: .main) {
        print("API is completed")
        results.forEach { result in
            if let data = result {
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }
    }
}

// MARK: - 2. Using OperationQueue
// OperationQueue is part of the Foundation framework and provides more control over task dependencies and priorities.
/**
 - `Pros`:
   - Offers more control over task dependencies and execution order.
   - Easy to limit concurrency.
 - `Cons`:
   - Verbose for simple tasks.
   - Requires careful handling to avoid deadlocks.
 */

func fetchDataUsingOperationQueue() {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 3
    
    let urls: [URL] = [
        URL(string: "https://jsonplaceholder.typicode.com/todos/1")!,
        URL(string: "https://jsonplaceholder.typicode.com/todos/2")!,
        URL(string: "https://jsonplaceholder.typicode.com/todos/3")!
    ]
    
    let completionOperation = BlockOperation {
        print("API is completed")
    }
    
    for url in urls {
        let operation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                }
                semaphore.signal()
            }.resume()
            semaphore.wait()
        }
        completionOperation.addDependency(operation)
        queue.addOperation(operation)
    }
    queue.addOperation(completionOperation)
}

// MARK: - 3. Using Combine
// Combine provides a declarative Swift API for handling asynchronous events, making it a powerful choice for concurrent API calls.
/**
 - `Pros`:
   - Declarative and modern.
   - Error handling is built-in and clean.
   - Works seamlessly with SwiftUI.
 - `Cons`:
   - Requires knowledge of Combine.
   - Limited to iOS 13 and above.
 */
var cancellables = Set<AnyCancellable>()

@MainActor
func fetchDataUsingCombine() {
    let urls: [URL] = [
        URL(string: "https://jsonplaceholder.typicode.com/todos/1")!,
        URL(string: "https://jsonplaceholder.typicode.com/todos/2")!,
        URL(string: "https://jsonplaceholder.typicode.com/todos/3")!
    ]
    
    let publishers = urls.map { url in
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .catch { _ in Just(Data()) }
            .eraseToAnyPublisher()
    }
    
    Publishers.MergeMany(publishers)
        .collect()
        .receive(on: DispatchQueue.main)
        .sink { data in
            switch data {
            case .finished:
                print("All API calls are completed")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        } receiveValue: { dataArray in
            dataArray.forEach { data in
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }
        .store(in: &cancellables)
}

// MARK: - 4. Using Async/Await
// The async/await pattern simplifies asynchronous code, introduced in Swift 5.5.
func fetchDataUsingAsyncAwait() async throws {
    let urls = [
        "https://jsonplaceholder.typicode.com/todos/1",
        "https://jsonplaceholder.typicode.com/todos/2",
        "https://jsonplaceholder.typicode.com/todos/3"
    ]
    
    try await withThrowingTaskGroup(of: String?.self) { group in
        var results: [String] = []
        results.reserveCapacity(urls.count)
        
        for urlString in urls {
            group.addTask {
                // Using optional try ensures that none of the endpoints interrupt the task execution.
                // If any task returns nil, the remaining tasks will continue to execute without being affected.  
                try? await fetchtData(with: urlString)
            }
        }
        
        for try await result in group {
            if let result {
                results.append(result)
            }
        }
    }
    
}

func fetchtData(with urlString: String) async throws -> String {
    return urlString
}

// MARK: - RunLoop.main vs. DispatchQueue.main
/**
 `Using DispatchQueue.main:`
 Consider the common scenario of fetching data asynchronously and updating the UI with the result. Here’s a snippet using `DispatchQueue.main` as a scheduler:
 */

class ViewModel: Decodable { }

URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://example.com/data")!)
    .map(\.data)
    .decode(type: ViewModel.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .sink { completion in
        /// `Handle completion`
    } receiveValue: { result in
        /// `Update UI with result   on the main thread`
    }
    .store(in: &cancellables)

/**
 `Using RunLoop.main:`
 Now, let’s explore the usage of `RunLoop.main` as a scheduler:
 */
URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://example.com/data")!)
    .map(\.data)
    .decode(type: ViewModel.self, decoder: JSONDecoder())
    .receive(on: RunLoop.main)
    .sink { completion in
        /// `Handle completion`
    } receiveValue: { result in
        /// `Update UI with 'result' on the main thread`
    }
    .store(in: &cancellables)

/**
 - At first glance, it seems that `RunLoop.main` serves the same purpose as `DispatchQueue.main`. Both ensure that UI updates occur on the main thread. However, there’s a crucial difference between them.

 `The Crucial Difference:`
 `The key difference between `RunLoop.main` and `DispatchQueue.main` lies in how they handle execution during user interactions. When using `RunLoop.main`, scheduled closures are subject to delays when user interactions, such as scrolling, are ongoing. In contrast, `DispatchQueue.main` executes closures immediately.`
 
 `Consider a scenario where you want to update the UI while the user is scrolling, such as displaying images. If you use `RunLoop.main`, the UI updates may be delayed until the scrolling stops, potentially affecting the user experience. On the other hand, `DispatchQueue.main` ensures immediate execution of UI updates.

 `In essence, `RunLoop.main` adheres to the main thread’s run loop and respects its modes, while `DispatchQueue.main` executes tasks without interruption.`
 */
