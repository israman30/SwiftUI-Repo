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
