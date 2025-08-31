import SwiftUI

/**
 `1. @State: Local UI State
 `@State` is the simplest and most commonly used `property wrapper` in SwiftUI.

 It allows a view to hold and manage its own `local state` (data that belongs only to that view).

 When a @State variable changes, `SwiftUI automatically re-renders the view` to reflect the new value. This makes building reactive UIs simple and declarative.
 */
struct CounterView: View {
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
