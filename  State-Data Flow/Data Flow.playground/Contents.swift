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

/**
 `@AppStorage & @SceneStorage: Persistence Made Simple
 @AppStorage is a property wrapper that connects a SwiftUI view directly to `UserDefaults`, allowing you to persist small pieces of data across app launches (like settings, preferences, or login state).
 */
struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        Toggle("Dark Mode", isOn: $isDarkMode)
            .padding()
    }
}
/**
 `@SceneStorage` is a property wrapper for preserving UI state tied to a specific scene (window or tab). Unlike `@AppStorag`e, it does not persist across app launches but remembers values while the app is running or when a scene becomes inactive (like when multitasking on iPad).
 */
struct ProfileView: View {
    @SceneStorage("username") private var username: String = ""

    var body: some View {
        TextField("Enter your name", text: $username)
            .padding()
    }
}
// Mini Example: Task Manager App
class TaskManager: ObservableObject {
    @Published var tasks: [String] = []
    
    func addTask(_ task: String) {
        tasks.append(task)
    }
}
struct AddTaskView: View {
    @State private var newTask = ""
    @EnvironmentObject var manager: TaskManager
    
    var body: some View {
        VStack {
            TextField("New Task", text: $newTask)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Add") {
                manager.addTask(newTask)
                newTask = ""
            }
        }
        .padding()
    }
}
struct TaskListView: View {
    @EnvironmentObject var manager: TaskManager
    
    var body: some View {
        List(manager.tasks, id: \.self) { task in
            Text(task)
        }
    }
}

//@main
struct TaskApp: App {
    @StateObject private var manager = TaskManager()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                AddTaskView()
                TaskListView()
            }
            .environmentObject(manager)
        }
    }
}

/**
 `Completion Block
 `- SwiftUI’s UI is driven by data & state.
 `- Use the correct property wrapper depending on ownership:
 `- @State → Local
 `- @Binding → Pass to child
 `- @ObservedObject → External model
 `- @StateObject → Lifecycle owner
 `- @EnvironmentObject → Shared across the app
 `- @AppStorage makes persistence effortless.
 */
