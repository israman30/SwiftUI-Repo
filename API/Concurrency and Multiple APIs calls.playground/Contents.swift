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
        
        for urlString in urls {
            group.addTask {
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
