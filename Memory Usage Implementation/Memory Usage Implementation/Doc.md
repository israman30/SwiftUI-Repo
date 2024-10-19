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
