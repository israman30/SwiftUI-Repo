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
