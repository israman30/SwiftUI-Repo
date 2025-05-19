import UIKit

/**
 What is `async let` ?
 async let lets you run independent `asynchronous` tasks concurrently and wait for their results only when needed, making your app more efficient by reducing wait times.
 */
func apiManagerA() { }

func apiManagerB() { }

func fecthData() async throws {
    let resultA = try await apiManagerA()
    let resultB = try await apiManagerB()
}

/**
 In this case, `apiManagerB()` will only start after `apiManagerBA()` finishes. This is sequential execution, even though both functions are asynchronous.

 Now, using async let, we can run both tasks concurrently:
 */

func fetchDataAsyncLet() async throws {
    async let resultA = apiManagerA()
    async let resultB = apiManagerB()
    
    let finalResultA = try await resultA
    let finalResultB = try await resultB
}
/**
 `Benefits of Using async let`
 - `Parallelism and Speed`: The most obvious benefit is that it allows you to run multiple tasks concurrently. This can lead to significant performance improvements when dealing with tasks like network requests, image processing, or database queries.

 - `Clean Syntax:` The async let syntax is straightforward. It makes your code more readable and easier to understand. Instead of dealing with callback hell or complex queue management, you can write linear-looking code that performs asynchronous tasks in parallel.

 - `Built-in Task Management:` Swift’s concurrency model takes care of task management, ensuring the execution of tasks in a safe and structured manner. async let tasks are scoped to the current function or block, and their results must be awaited before exiting the scope, preventing potential memory leaks or unfinished tasks.

 `Automatic Propagation of Errors:` Any errors that occur in the tasks are automatically thrown when awaiting the results, making error handling more intuitive.
 */
/**
 `Where to Use async let``
 1. `Network Calls:` If your app relies on fetching data from multiple APIs, async let allows you to perform these calls concurrently and handle the results when they are all ready.
 2. `File I/O Operations:` Reading or writing to multiple files can be done concurrently using async let, saving time when dealing with large amounts of data.
 3. `Image Processing:` You can use async let to apply multiple image filters concurrently, allowing the user to see processed images faster.
 4. `Database Queries:` Querying multiple tables or datasets concurrently can significantly reduce the time it takes to gather data from a database.
 */

/**
 `Caution: When Not to Use async let``
 While `async let` is powerful, it’s not suitable for every situation:

 - `Tightly Coupled Tasks:` If one task depends on the result of another, you should not use async let. In such cases, tasks need to run sequentially.
 - `UI Updates:` Avoid performing UI updates in parallel unless each update is independent. UI changes typically need to be done on the main thread, so parallelism might introduce bugs if not handled carefully.
 */
