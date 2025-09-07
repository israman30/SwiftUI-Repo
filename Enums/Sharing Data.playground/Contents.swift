import UIKit
import SwiftUI

class MyViewModel: ObservableObject {
    @Published var text: String = "Hello, World!"
}

// UIKit - UIViewController
class ViewController: UIViewController {
    private let textField = UITextField()
    private var myviewModel = MyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            self?.myviewModel.text = self?.textField.text ?? ""
            let contentView = ContentView(viewModel: self!.myviewModel)
            let hostViewController = UIHostingController(rootView: contentView)
            self?.present(hostViewController, animated: true)
        }))
        
        button.setTitle("Present SwiftUI", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
}

// SwiftUI - ContentView
struct ContentView: View {
    @ObservedObject var viewModel: MyViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.text)
            TextField("Enter text", text: $viewModel.text)
        }
    }
}
