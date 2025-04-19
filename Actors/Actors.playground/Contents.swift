import UIKit

/**
 `Actors guarantee that their mutable state is accessed by only one thread at a time. This prevents data corruption and ensures integrity.
 `When Should You Use Actors?`
 Use actors when your app needs to handle shared data across multiple concurrent tasks. They’re especially helpful in highly asynchronous environments, where class-based managers can be replaced with actors that safely mutate state.

 `Why Not Use Structs?`

 Structs are value types, and copying them avoids shared state. The real concurrency issues happen with reference types like classes. That’s why actors matter.


 */

class Dinner {
    var value = 0

    func eat() {
        value += 1
    }
}

let dinner = Dinner()

// Simulate concurrent access
Task {
    await withTaskGroup(of: Void.self) { group in
        for i in 0..<30 {
            if i % 2 == 0 { dinner.value -= 1 }
            group.addTask {
                //await dinner.eat() // ⚠️ Not thread-safe!
            }
        }
    }
    print("Final value (class): \(dinner.value)")
}

/**
 `How Actors Solve This`
 With actors, this problem goes away. You simply can’t access the actor’s internal state directly from outside. The compiler won’t let you
 */
actor SafeDinner {
    var value = 0
    
    func eat() {
        value += 1
    }
    
    func getValue() async -> Int {
        value
    }
}

let meal = SafeDinner()

Task {
    await withTaskGroup(of: Void.self) { group in
        for i in 0..<30 {
            if i % 2 == 0 {
                group.addTask {
                    await meal.eat() // ✅ Safe access
                }
            }
        }
    }
}


/// `A More Advanced Example: Chat Server`

struct Message {
    let user: String
    let content: String
    let timestamp: Date
}

actor ChatServer {
    private var messages: [Message] = []

    func postMessage(from user: String, content: String) {
        let message = Message(user: user, content: content, timestamp: Date())
        messages.append(message)
    }

    func getMessages() -> [Message] {
        return messages.sorted { $0.timestamp < $1.timestamp }
    }
}

struct Main {
    static func chat() async {
        let server = ChatServer()
        let users = ["Alice", "Bob", "Charlie", "Diana"]

        print("Starting to post messages...")

        await withTaskGroup(of: Void.self) { group in
            for user in users {
                group.addTask {
                    for i in 1...5 {
                        print("Posting message \(i) from \(user)")
                        await server.postMessage(from: user, content: "Message \(i) from \(user)")
                        try? await Task.sleep(nanoseconds: UInt64.random(in: 10_000_000...50_000_000))
                    }
                }
            }
        }

        print("Finished posting messages. Retrieving all messages...")

        let allMessages = await server.getMessages()
        for message in allMessages {
            print("[\(message.timestamp)] \(message.user): \(message.content)")
        }

        print("All messages printed.")
    }
}

/**
 `In this example, the actor ensures that messages are updated safely, even when multiple users are posting at the same time.`
 
 Starting to post messages...
 Posting message 1 from Alice
 Posting message 1 from Bob
 Posting message 1 from Charlie
 Posting message 1 from Diana
 Posting message 2 from Alice
 Posting message 2 from Bob
 Posting message 2 from Diana
 Posting message 2 from Charlie
 Posting message 3 from Alice
 Posting message 3 from Bob
 Posting message 3 from Charlie
 Posting message 3 from Diana
 Posting message 4 from Charlie
 Posting message 4 from Diana
 Posting message 4 from Bob
 Posting message 4 from Alice
 Posting message 5 from Diana
 Posting message 5 from Charlie
 Posting message 5 from Bob
 Posting message 5 from Alice
 Finished posting messages. Retrieving all messages...
 [2025-04-17 19:14:11 +0000] Alice: Message 1 from Alice
 [2025-04-17 19:14:11 +0000] Bob: Message 1 from Bob
 [2025-04-17 19:14:11 +0000] Charlie: Message 1 from Charlie
 [2025-04-17 19:14:11 +0000] Diana: Message 1 from Diana
 [2025-04-17 19:14:11 +0000] Alice: Message 2 from Alice
 [2025-04-17 19:14:11 +0000] Bob: Message 2 from Bob
 [2025-04-17 19:14:11 +0000] Diana: Message 2 from Diana
 [2025-04-17 19:14:11 +0000] Charlie: Message 2 from Charlie
 [2025-04-17 19:14:11 +0000] Alice: Message 3 from Alice
 [2025-04-17 19:14:11 +0000] Bob: Message 3 from Bob
 [2025-04-17 19:14:11 +0000] Charlie: Message 3 from Charlie
 [2025-04-17 19:14:11 +0000] Diana: Message 3 from Diana
 [2025-04-17 19:14:11 +0000] Charlie: Message 4 from Charlie
 [2025-04-17 19:14:11 +0000] Diana: Message 4 from Diana
 [2025-04-17 19:14:11 +0000] Bob: Message 4 from Bob
 [2025-04-17 19:14:11 +0000] Alice: Message 4 from Alice
 [2025-04-17 19:14:11 +0000] Diana: Message 5 from Diana
 [2025-04-17 19:14:11 +0000] Charlie: Message 5 from Charlie
 [2025-04-17 19:14:11 +0000] Bob: Message 5 from Bob
 [2025-04-17 19:14:11 +0000] Alice: Message 5 from Alice
 All messages printed.
 */


