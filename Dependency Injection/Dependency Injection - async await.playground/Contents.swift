import SwiftUI
import PlaygroundSupport

let endpoint = "https://jsonplaceholder.typicode.com/users"

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

// MARK: - API
protocol NetworkServicesProtocol {
    func fetchData(_ url: URL) async throws -> Data
}

class NetworkServices: NetworkServicesProtocol {

    private var urlSession: URLSession
    
    init(with urlSession: URLSession = URLSession(configuration: .ephemeral)) {
        self.urlSession = urlSession
    }
    
    func fetchData(_ url: URL) async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}

// MARK: - VIEW MODEL
class ViewModel: ObservableObject {
    
    private var networkSession: NetworkServicesProtocol
    
    @Published var users = [User]()
    
    init(with networkSession: NetworkServicesProtocol = NetworkServices()) {
        self.networkSession = networkSession
    }
    
    @MainActor
    func getUsers() async throws {
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        let data = try await networkSession.fetchData(url)
        let usersResponse = try JSONDecoder().decode([User].self, from: data)
        users = usersResponse
    }
}


// MARK: - View
struct UsersList: View {
    
    @StateObject private var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(with: NetworkServices()))
    }
    
    var body: some View {
        VStack {
            List(vm.users, id: \.id) {
                Text($0.name)
            }
        }
        .task {
            await load()
        }
        .refreshable {
            await load()
        }
    }
    
    func load() async {
        do {
            try await vm.getUsers()
        } catch {
            print(error.localizedDescription)
        }
    }
}

PlaygroundPage.current.setLiveView(UsersList())
