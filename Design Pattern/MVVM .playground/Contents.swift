import SwiftUI

/**
 `MVVM` `(Model-View-ViewModel)` is a software design pattern that separates an application into three interconnected parts: the `Model`,
 `View`, and `ViewModel`.
 This separation helps organize code, making it more maintainable, testable, and reusable.
 The `ViewModel` acts as an intermediary between the `View` and `Model`, handling presentation logic and data binding.
 */
/**
 `Components Overview and their roles
 - `View (Controller - UIKit):` It only performs things related to UI — Show/get information. Part of the view layer
 - `View Model`: It receives information from VC, handles all this information, and sends it back to VC.
 - `Model: `This is only your model, nothing much here. It’s the same model as in MVC. It is used by VM and updates whenever VM sends new updates
 */

// MARK: - Model
/**
 🧩 `Model`
 The Model represents the application's data and business logic. It encapsulates the core functionalities and rules, independent of the user interface.
 This separation ensures that the business logic remains unaffected by changes in the UI.
 */
struct User: Codable {
    let name: String
    let email: String
}

// MARK: - Network Layer
protocol NetworkLayerProtocol {
    func fetchUserData() -> User?
}

class NetworkLayer: NetworkLayerProtocol {
    func fetchUserData() -> User? {
        return User(name: "John", email: "john@example.com")
    }
}

// MARK: - View Model
/**
 🔄 `ViewModel`
 The ViewModel acts as an intermediary between the Model and the View. It retrieves data from the Model, processes it if necessary, and exposes it in a form suitable for the View.
 Additionally, it handles user interactions passed from the View, updating the Model accordingly.
 This component facilitates two-way data binding, ensuring synchronization between the UI and the underlying data.
 */
class ViewModel: ObservableObject {
    var users = [User]()
    let netwokLayer: NetworkLayerProtocol
    
    init(_ netwokLayer: NetworkLayerProtocol) {
        self.netwokLayer = netwokLayer
    }
    
    func fetchUser() {
        // fetch data
    }
}

// MARK: - View
/**
 🖼️ `View`
 The View is the user interface of the application. It displays data provided by the ViewModel and captures user interactions, such as clicks or text input.
 The View is designed to be as simple as possible, focusing solely on presenting information and forwarding user actions to the ViewModel.
 */
struct RootView: View {
    /// Injecting User Object once
    @StateObject private var viewModel: ViewModel = .init(NetworkLayer())
    
    /// or Injecting like:
     /**
      ```
      init(viewModel: ViewModel) {
          self._viewModel = .init(wrappedValue: viewModel)
      }
     */
    
    var body: some View {
        VStack {
            ChildView(viewModel: viewModel)
        }
    }
}

struct ChildView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Text("Child View")
    }
}
