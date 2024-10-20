//
//  Doc.swift
//  Memory Usage Implementation
//
//  Created by Israel Manzo on 10/18/24.
//
/*
 Understanding SwiftUI’s Memory Management
 SwiftUI’s declarative nature means that the UI is a function of its state. Views are lightweight,
 immutable structures that are recreated when the state changes. However, the data and objects that views interact with can be heavy,
 especially when dealing with large datasets, media files, or complex object graphs. Understanding how SwiftUI manages memory and state is essential for
 optimization.
 
 */
// MARK: - State Management and Memory
/// SwiftUI provides several property wrappers for state management: @State, @Binding, @ObservedObject, @StateObject, and @EnvironmentObject. Each has different implications for memory usage and lifecycle management.

/// `@State`: Used for simple, view-local state. SwiftUI manages the storage.
/// `@Binding`: A reference to state stored elsewhere.
/// `@ObservedObject`: For observing changes in an object provided from elsewhere. SwiftUI does not manage its lifecycle.
/// `@StateObject`: Similar to @ObservedObject, but SwiftUI creates and owns the lifecycle of the object.
/// `@EnvironmentObject`: For dependency injection via the environment; shared data accessible throughout the view hierarchy.
///
// Proper use of these property wrappers is crucial to prevent unnecessary memory allocations and retain cycles.

// MARK: - Advanced Techniques for Memory Optimization
// Appropriate Use of @StateObject and @ObservedObject

// Avoid Unnecessary Object Creation and Retention

/// When using `@StateObject`, `SwiftUI` initializes the object only once for the lifetime of the view, even when the view is recreated due to state changes. Overusing `@StateObject` can lead to excessive memory usage if not managed properly.

// Incorrect Usage Example:
struct ContentView: View {
    @StateObject private var viewModel = LargeDataViewModel()

    var body: some View {
        // UI that uses viewModel
    }
}
// In this example, every instance of ContentView holds its own LargeDataViewModel, potentially leading to multiple copies of a heavy object in memory.

// Optimized Approach:
/// Use `@ObservedObject` when the view model is provided from a parent view or injected, avoiding unnecessary instantiation.
/// Consider singleton patterns or shared instances when appropriate.
struct ContentView: View {
    @ObservedObject var viewModel: LargeDataViewModel

    var body: some View {
        // UI that uses viewModel
    }
}

// Elsewhere in your app, inject the shared viewModel
let sharedViewModel = LargeDataViewModel()

ContentView(viewModel: sharedViewModel)

// Technical Insight:

/// `@ObservedObject` does not manage the object’s lifecycle. It simply observes the object for published changes. By injecting the viewModel, you have control over its creation and scope, allowing for better memory management.


// MARK: - Leveraging `Lazy` Loading with LazyVStack and LazyHStack
// Efficiently Rendering Large Data Sets

/// Standard `VStack` and `HStack` load all their child views immediately, which can be problematic with large data sets.

// Optimized Usage:
ScrollView {
    LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
        ForEach(largeDataSet) { item in
            DataRowView(item: item)
        }
    }
}

// Technical Details:
/// `LazyVStack` and `LazyHStack` only create views as needed, based on the visible content area.
/// The pinnedViews parameter allows for efficient handling of section headers and footers.
// This `lazy` loading reduces initial memory consumption and improves performance when scrolling.


// MARK: - Efficient Image Loading and Caching
// Avoid Loading Full-Size Images When Not Necessary Loading high-resolution images can consume significant memory. Displaying thumbnails or lower-resolution images where appropriate can mitigate this.

// Implementation:
struct ThumbnailView: View {
    let imageURL: URL

    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                // Handle error
                Color.red
            } else {
                // Placeholder
                ProgressView()
            }
        }
        .frame(width: 100, height: 100)
    }
}

// Advanced Image Caching:
// Implementing a custom image cache to avoid redundant network or disk fetches:
class ImageCache {
    static let shared = ImageCache()

    private init() {}

    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: NSURL) -> UIImage? {
        return cache.object(forKey: url)
    }

    func insertImage(_ image: UIImage?, for url: NSURL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url)
    }
}

// Usage in a View:
struct CachedAsyncImage: View {
    let url: URL

    @State private var uiImage: UIImage?

    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    let uiImage = image.asUIImage()
                    ImageCache.shared.insertImage(uiImage, for: url as NSURL)
                    self.uiImage = uiImage
                    image.resizable()
                } else if phase.error != nil {
                    Color.red
                } else {
                    ProgressView()
                }
            }
        }
    }
}

// Technical Insight:

// - `NSCache` is thread-safe and automatically purges cached items to free up memory.
// - By caching images, you minimize memory usage by preventing multiple instances of the same image in memory.
// - Ensure that image caching strategies do not retain images longer than necessary.


// MARK: - Offloading Heavy Computations
// Avoid Performing Intensive Tasks in the View Body

// Computations in the body property of a view are re-executed whenever the view updates, which can lead to performance issues and increased memory usage.

// Inefficient Example:
struct ContentView: View {
    var body: some View {
        let processedData = heavyComputation()
        return Text("Data: \(processedData)")
    }
}

// Optimized Approach:
// Use background threads to perform heavy computations and update the UI upon completion.
struct ContentView: View {
    @State private var processedData: String = ""

    var body: some View {
        Text("Data: \(processedData)")
            .onAppear {
                DispatchQueue.global(qos: .userInitiated).async {
                    let data = heavyComputation()
                    DispatchQueue.main.async {
                        self.processedData = data
                    }
                }
            }
    }
}

// Technical Details:

/// Using `DispatchQueue.global` offloads the computation to a background thread, preventing the UI from blocking.
// Updating @State properties on the main thread ensures UI updates are thread-safe.
/// Consider using `OperationQueue` or `Combine’s Publishers` for more complex`asynchronous` tasks.


// MARK: - Prefer Value Types Over Reference Types
// Utilizing Swift’s Copy-on-Write Semantics

// Value types like struct and enum in Swift benefit from copy-on-write optimizations, reducing unnecessary memory copying and allocations.

// Example:
struct DataModel {
    var items: [Item]
}
// Technical Insight:

/// `Arrays`, `dictionaries`, and `other collections` in Swift are `value types` with `copy-on-write behavior`.
// Modifying a value type only copies the data if it has been shared elsewhere, reducing memory footprint.
// Reference types (class) can lead to unintended sharing and retain cycles if not managed carefully.

// MARK: - Explicit Resource Cleanup
// Ensure Deallocation of Unused Resources

// For heavy objects like media players, database connections, or large data buffers, explicitly releasing resources when they’re no longer needed is crucial.

// Implementation:
class VideoPlayerViewModel: ObservableObject {
    private var player: AVPlayer?

    func setupPlayer(with url: URL) {
        player = AVPlayer(url: url)
    }

    func cleanup() {
        player?.pause()
        player = nil
    }
}

struct VideoPlayerView: View {
    @StateObject var viewModel = VideoPlayerViewModel()

    var body: some View {
        VideoPlayer(player: viewModel.player)
            .onDisappear {
                viewModel.cleanup()
            }
    }
}

// Technical Details:

// Setting player to nil allows ARC to deallocate the AVPlayer instance if there are no other strong references.
// Pausing the player before deallocation ensures that any playing media is properly stopped.
// Be cautious with onDisappear, as it may not always be called in certain navigation scenarios; consider using Task cancellation tokens in Swift concurrency.

// MARK: - Minimizing Unnecessary View Updates
// Using Equatable Views to Optimize Rendering

// SwiftUI’s diffing algorithm can be optimized by conforming views to Equatable when appropriate.

// Implementation:
struct EquatableContentView: View, Equatable {
    let data: DataModel

    static func == (lhs: EquatableContentView, rhs: EquatableContentView) -> Bool {
        return lhs.data.id == rhs.data.id
    }

    var body: some View {
        // UI that uses data
    }
}

// Technical Insight:

/// By conforming to `Equatable`, SwiftUI can skip rendering the view if the data hasn’t changed, reducing `CPU and memory usage`.
/// Only use `Equatable` when you can provide a meaningful and `efficient == implementation`.
// Be careful with complex data models; deep equality checks can negate performance benefits.
