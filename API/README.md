## SwiftUI Networking + Concurrency + Combine + WebSockets (Samples)

This folder contains multiple small Xcode projects and playgrounds that demonstrate different approaches to:

- **Networking**: `URLSession`, `URLRequest`, `URLComponents`, `JSONDecoder`/`JSONEncoder`
- **Concurrency**: GCD (`DispatchGroup`), `OperationQueue`, and Swift Concurrency (`Task`, `async/await`, `TaskGroup`)
- **Combine**: `Publisher` pipelines, `@Published`, `AnyCancellable`, `Subject`s
- **WebSockets**: `URLSessionWebSocketTask` with reconnect + ping/pong
- **Observability**: request/response logging using `OSLog`

### Projects in this folder

- **Classic Networking (completion handlers)**: `Networking/`
- **Networking with async/await**: `Networking with async/`
- **Networking with Combine**: `Networking with Combine/`
- **Advanced Networking (typed routes + request model + error mapping)**: `Advance Networking/`
- **Network Logging & Observability (OSLog)**: `Network Logging & Observability/`
- **WebSockets (URLSessionWebSocketTask)**: `Websockets/`
- **Concurrency patterns playground**: `Concurrency and Multiple APIs calls.playground/`
- **Mastering Networking (CoinGecko example)**: `Mastering Networking/`

To run any sample, open the corresponding `.xcodeproj` inside its folder (for example: `Websockets/Websockets.xcodeproj`) and run the app target.

---

## Networking components

### `URLSession` + JSON decoding (completion handler style)

- **Used in**: `Networking/Networking/NetworkServices/NetworkServices.swift`
- **Key components**:
  - `URLSession.shared.dataTask(with:)`
  - `JSONDecoder().decode(...)`
  - UI handoff via `DispatchQueue.main.async`
  - `ObservableObject` + `@Published` for SwiftUI updates

### `URLSession` + JSON decoding (async/await style)

- **Used in**: `Networking with async/Networking with async/Utils/NetworkServices.swift`
- **Key components**:
  - `URLSession.shared.data(from:)`
  - `async throws` API surface
  - `HTTPURLResponse` status-code validation
  - `JSONDecoder` decoding into `[User]`

### “Advanced Networking” building blocks (typed request + shared execution)

- **Used in**: `Advance Networking/Advance Networking/NetworkServices/`
- **Request model**: `APIRequest<Response>`
  - **File**: `Advance Networking/Advance Networking/NetworkServices/APIRequest.swift`
  - **Key components**:
    - `HTTPMethod` enum for verbs
    - `APIRoutes` for typed routing (`Advance Networking/Advance Networking/NetworkServices/Routes.swift`)
    - `URLComponents` + `URLQueryItem` for query construction
    - header merging (`defaultHeaders` + per-request headers)
    - JSON body encoding via `JSONEncoder` (generic `Encodable` initializer)
- **Executor**: `APIClient`
  - **File**: `Advance Networking/Advance Networking/NetworkServices/APIClient.swift`
  - **Key components**:
    - `URLSession.data(for:)` for `URLRequest` execution
    - `JSONDecoder` for response decoding
    - HTTP status validation (2xx success)
    - dependency injection for `URLSession` and `JSONDecoder` (testability)
- **Error modeling**: `NetworkError` + mapping
  - **File**: `Advance Networking/Advance Networking/NetworkServices/NetworkError.swift`
  - **Key components**:
    - `LocalizedError` conformance for UI-friendly messages
    - mapping from `URLError` → `.transport(...)`
    - separation of **user-facing** (`userMessage`) vs **debug** (`debugMessage`)
- **Feature services** (build request + call client)
  - **User service**: `Advance Networking/Advance Networking/Core/User/Service/UserService.swift`
  - **Post service**: `Advance Networking/Advance Networking/Core/Post/Service/PostService.swift`

---

## Concurrency components

### Grand Central Dispatch (GCD)

- **Used in**: `Concurrency and Multiple APIs calls.playground/Contents.swift`
- **Key components**:
  - `DispatchGroup` to coordinate multiple `URLSession.dataTask` calls
  - `DispatchSemaphore` to block an `OperationQueue` `BlockOperation` until a request finishes
  - `DispatchQueue.main` (or `.main.async`) when results must update UI

### `OperationQueue`

- **Used in**: `Concurrency and Multiple APIs calls.playground/Contents.swift`
- **Key components**:
  - `OperationQueue.maxConcurrentOperationCount` to limit concurrency
  - `BlockOperation` + dependencies to run a completion operation after all requests

### Swift Concurrency (`async/await`)

- **Used in**:
  - `Networking with async/Networking with async/Utils/NetworkServices.swift`
  - `Concurrency and Multiple APIs calls.playground/Contents.swift`
  - `Websockets/Websockets/ViewModel/ChatViewModel.swift`
  - `Websockets/Websockets/WebsocketServices.swift`
- **Key components**:
  - `async throws` functions
  - `Task { ... }` for structured background work
  - `Task.sleep(nanoseconds:)` for time-based behavior (typing indicator, ping, reconnect backoff)
  - `withThrowingTaskGroup` for fan-out/fan-in concurrent work (playground example)
  - `@MainActor` on view models that mutate UI state (`ChatViewModel`)

---

## Combine components

### Combine + `URLSession.dataTaskPublisher`

- **Used in**: `Networking with Combine/Networking with Combine/Utils/NetworkServices.swift`
- **Key components**:
  - `URLSession.shared.dataTaskPublisher(for:)`
  - `.receive(on: RunLoop.main)` for UI updates
  - `.map(\.data)` and `.decode(type:decoder:)`
  - `.eraseToAnyPublisher()` to hide publisher implementation details
  - `AnyCancellable` / `Cancellable` for lifecycle management
  - `.sink(receiveCompletion:receiveValue:)` to consume results

### Combine for coordinating many requests

- **Used in**: `Concurrency and Multiple APIs calls.playground/Contents.swift`
- **Key components**:
  - `Publishers.MergeMany` to run many publishers in parallel
  - `.collect()` to wait for all values before producing an array

### Combine bridging for WebSocket state + events

- **Used in**: `Websockets/Websockets/WebsocketServices.swift`
- **Key components**:
  - `CurrentValueSubject<ConnectionState, Never>` for latest connection state
  - `PassthroughSubject<WebsocketEvent, Never>` for incoming events stream
  - public `AnyPublisher` APIs via `.eraseToAnyPublisher()`

---

## WebSocket components

### `URLSessionWebSocketTask` service (connect / send / receive / ping / reconnect)

- **Used in**: `Websockets/Websockets/WebsocketServices.swift`
- **Key components**:
  - `URLSession(configuration:delegate:delegateQueue:)`
  - `URLSession.webSocketTask(with:)`
  - `URLSessionWebSocketTask.send(_:)` + `receive()`
  - `URLSessionWebSocketTask.sendPing(...)` for keep-alive
  - `URLSessionWebSocketDelegate`:
    - `didOpenWithProtocol` to emit `.connected`
    - `didCloseWith` to handle closure + trigger reconnect
  - reconnect with bounded retries + exponential backoff (`Task.sleep`)
  - message modeling:
    - `WebsocketEvent: Codable` for typed events (`Websockets/Websockets/Websocket.swift`)
    - `ChatMessage` and simple `TokenManager` placeholder (`Websockets/Websockets/Model/Chat.swift`)

### SwiftUI integration (view model)

- **Used in**: `Websockets/Websockets/ViewModel/ChatViewModel.swift`
- **Key components**:
  - `ObservableObject` + `@Published` state for messages, typing, and connection state
  - Combine subscriptions to `connectionState` + `receivedEvents`
  - `@MainActor` to keep UI mutations consistent
  - typing indicator debounce implemented with a cancellable `Task`

> Note: the WebSocket endpoint string in `WebsocketServices.swift` currently uses a placeholder (`"constants.wsEndpoint"`). Replace it with your real `wss://...` endpoint (or wire it to a `Constants` type) before running against a backend.

---

## Logging & Observability components

### Request/response logging with `OSLog`

- **Used in**:
  - `Network Logging & Observability/Network Logging & Observability/NetworkLogger.swift`
  - `Network Logging & Observability/Network Logging & Observability/NetworkManager.swift`
- **Key components**:
  - `OSLog` via `Logger(subsystem:category:)`
  - structured log levels (`request`, `response`, `success`, `warning`, `error`)
  - JSON pretty printing + truncation for large response bodies
  - end-to-end instrumentation (log request → log response → log decode → log errors)

