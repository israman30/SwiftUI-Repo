import UIKit

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
