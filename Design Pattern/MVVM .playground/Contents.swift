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

struct User: Codable {
    let name: String
    let email: String
}

protocol NetworkLayerProtocol {
    func fetchUserData() -> User?
}

class NetworkLayer: NetworkLayerProtocol {
    func fetchUserData() -> User? {
        return User(name: "John", email: "john@example.com")
    }
}

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
