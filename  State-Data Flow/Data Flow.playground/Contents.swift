import SwiftUI

/**
 `1. @State: Local UI State
 `@State` is the simplest and most commonly used `property wrapper` in SwiftUI.

 It allows a view to hold and manage its own `local state` (data that belongs only to that view).

 When a @State variable changes, `SwiftUI automatically re-renders the view` to reflect the new value. This makes building reactive UIs simple and declarative.
 */
struct Counter: View {
    @State private var count = 0   // Local UI state
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.largeTitle)
            
            Button("Increment") {
                count += 1   // Updates UI automatically
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

/**
 `@Binding: Sharing State with Child Views
 While `@State` creates and owns local state inside a view, sometimes we want a child view to read and modify state that belongs to its parent view.

 That’s where `@Binding` comes in. It acts like a two-way connection (a reference) to the parent’s `@State` variable.

 This allows child views to mutate the parent’s state directly, without creating a separate copy.
 */
struct ParentView: View {
    @State private var isOn = false   // State owned by parent
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Enable Feature", isOn: $isOn)  // Direct binding
                .padding()
            
            ChildSwitchView(isOn: $isOn)   // Pass binding to child
        }
    }
}

struct ChildSwitchView: View {
    @Binding var isOn: Bool   // Binding, not ownership
    
    var body: some View {
        Button(isOn ? "Turn Off" : "Turn On") {
            isOn.toggle()    // Updates parent state
        }
        .padding()
        .background(isOn ? .green : .red)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

/**
 `@ObservedObject & @Published– Observing Models
 While `@State` and `@Bindin`g are great for local view state or parent-child communication, they’re not ideal for shared or complex data models used across multiple views.

 That’s where `@ObservedObject` and `@Published` come in.

 `@ObservedObject`: A property wrapper for referencing an `external model` (a class conforming to ObservableObject).
 `@Published`: Marks properties inside that model so that when they change, `all observing views automatically update`.
 */
// Model
class CounterModel: ObservableObject {
    @Published var count: Int = 0   // Any change triggers view updates
}

// View
struct CounterView: View {
    @ObservedObject var counter = CounterModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(counter.count)")
                .font(.largeTitle)
            
            HStack {
                Button("Increment") {
                    counter.count += 1
                }
                Button("Decrement") {
                    counter.count -= 1
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
/**
 `@Published = notify changes in the model.

 `@ObservedObject = observe those changes inside a view.
 */

/**
 `@StateObject vs @ObservedObject
 @StateObject → The `view creates and owns` the object.
 @ObservedObject → The object is `passed in from outside.`
 */

/**
 `@EnvironmentObject: App-Wide Data
 @EnvironmentObject is a property wrapper that lets you share a single instance of data across multiple views in your app without manually passing it through each view’s initializer.
 It’s designed for `global or app-wide state.`
 */
class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

// @main
struct MyApp: App {
    @StateObject private var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session) // Provide once
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        VStack {
            Text(session.isLoggedIn ? "Welcome back!" : "Please log in")
            Button("Toggle Login") {
                session.isLoggedIn.toggle()
            }
        }
    }
}
