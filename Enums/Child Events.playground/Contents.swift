import SwiftUI

// Step 1: Define Your Events
enum ChildEvent {
    case edit
    case delete
    case share
}

// Step 2: Child View with a Single Closure
struct ChildView: View {
    var onEvent: (ChildEvent) -> Void
    
    var body: some View {
        HStack {
            Button("Edit") {
                onEvent(.edit)
            }
            
            Button("Delete") {
                onEvent(.delete)
            }
            
            Button("Share") {
                onEvent(.share)
            }
        }
    }
}

// Step 3: Parent View Handles Events
struct ParentView: View {
    
    var body: some View {
        VStack {
           Text("Parent View")
                .font(.title)
                .padding()
            
            ChildView { event in
                handleChildEvent(event)
            }
        }
    }
    
    private func handleChildEvent(_ event: ChildEvent) {
        switch event {
        case .edit:
            print("Edit tapped")
        case .delete:
            print("Delete tapped")
        case .share:
            print("Share tapped")
        }
    }
}
