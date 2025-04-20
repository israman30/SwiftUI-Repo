//
//  ContentView.swift
//  Coordinator Deep Advance
//
//  Created by Israel Manzo on 4/19/25.
//

import SwiftUI
/**
 The `Coordinator Pattern` is a design pattern used to manage the navigation flow and communication between view controllers (or views in SwiftUI). The core idea is to move navigation logic out of the views and centralize it into separate coordinator objects.
 `Principles of the Coordinator Pattern:`
 Separation of Concerns — UI components remain focused on presenting data and UI elements, while coordinators manage navigation logic.
 `1. Scalability` — It simplifies complex navigation flows by breaking them into smaller, manageable coordinators.
 `2. Testability` — Since navigation logic is removed from UI components, it becomes easier to test independently.
 `3. Reusability` — Coordinators can be reused across different parts of the application, reducing code duplication.
 `4. Extensibility` — New navigation flows can be added with minimal changes to existing views, keeping the architecture flexible.
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

/**
 `1. Define the Coordinator Protocol
 The coordinator will be responsible for handling navigation events. We define a common protocol for all coordinators:
 */
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

/**
 `2. Create a Base Coordinator
 We can create a base AppCoordinator to handle the app’s main navigation flow and manage child coordinators.
 */
class AppCoordinator: ObservableObject, Coordinator {
    @Published var path = NavigationPath()
    var childCoordinators: [Coordinator] = []
    
    func start() {
        // setup
    }
    
    func navigateToDetail(with item: String) {
        path.append(item)
    }
    
    func rootView() {
        path.removeLast(path.count)
    }
}

/**
 `3. Integrate the Coordinator with SwiftUI
 Now, let’s integrate the AppCoordinator with a SwiftUI view.
 */
struct CoordinatorView: View {
    @StateObject var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                
            }
        }
    }
}

/// `4. Define the Detail View
struct DetailView: View {
    var body: some View {
        Text("Detail View")
    }
}

/**
 `Advanced Coordinator Pattern Implementations
 `1. Using Nested Coordinators for Complex Flows
 In large applications, you might need multiple coordinators for different sections of your app. Here’s how you can handle nested coordinators:
 */
class ProfileCoordinator: Coordinator {
    @Published var path = NavigationPath()
    var childCoordinators: [Coordinator] = []
    
    func start() {
        // setup
    }
    
    func navgiateToSettings(settings: String) {
        path.append(settings)
    }
}

/// `Then, use it inside AppCoordinator:
/**
 ```swift
 class AppCoordinator: ObservableObject, Coordinator {
     @Published var path = NavigationPath()
     var childCoordinators: [Coordinator] = []
     let profileCoordinator = ProfileCoordinator()
 }
```
 */
/**
` 2. Handling UIKit Integrations
 If you need to present a `UIKit` `UIViewController` within `SwiftUI`, you can use `UIViewControllerRepresentable` with a `coordinator`:
 
 ```swift
 struct CameraViewController: UIViewRepresentable {
     class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
         var parent: CameraView
         
         init(parent: CameraView) {
             self.parent = parent
         }
     }
     
     func makeCoordinator() -> Coordinator {
         return Coordinator(parent: self)
     }
 }
```
 */
/**
 ```
 App Root -> Detail Coordinator -> Detail View
 App Root -> Main Coordinator -> Root View -> NavigationView
 ```
 - `App (Root):` The entry point of the app. It holds a reference to the root coordinator.
 - `Coordinator Protocol`: The base protocol that defines methods for navigating between screens, typically including a start() method.
 - `MainCoordinator:` A concrete implementation of the Coordinator protocol, managing navigation logic for the main screen (e.g., the home screen). It is responsible for initializing the main view and managing navigation.
 - `DetailCoordinator`: A coordinator that handles navigation and presentation logic for a detailed view, such as navigating to a detail page from the main screen.
 - `RootView:` The main content view managed by the MainCoordinator.
 - `DetailView:` A detail screen that is displayed when the user navigates from the MainCoordinator.
 - `NavigationView:` The container for the navigation logic, usually used for pushing views onto a stack in SwiftUI.
 */
