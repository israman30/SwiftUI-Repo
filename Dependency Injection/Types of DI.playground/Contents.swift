import UIKit

protocol NetworkServicesProtocol {
    func load() -> String
}

// MARK: - Network Layer
final class NetworkServices: NetworkServicesProtocol {
    func load() -> String {
        "Some data loaded"
    }
}

// MARK: - NO Dependency Injection
class ViewModel_No_DI {
    var services: NetworkServicesProtocol = NetworkServices()
}

// MARK: - Initilizer Injection
class ViewModel_Initializer_Injection {
    
    private var services: NetworkServicesProtocol
    
    init(services: NetworkServicesProtocol) {
        self.services = services
    }
    
    func fetchData() -> String {
        services.load()
    }
}

// MARK: - Property Injection
class ViewModel_Property_Injection {
    var services: NetworkServicesProtocol?
}

// MARK: - Method Injection
class ViewModel_Method_Injection {
    func fetchData(services: NetworkServicesProtocol) -> String {
        services.load()
    }
}
