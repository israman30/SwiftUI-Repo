# SwiftUI-Repo

### The repository is grounded in samples and blueprints of iOS methodologies, offering insights into the development of applications, frameworks, and playgrounds.

#### 1. Creating a custom Card

   ```CustomCardView``` ```SwiftUI``` declares the custom card.
   ```swift
   struct CustomCardView: View {
      var body: some View {
          VStack(alignment: .leading) {
              Image("world")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              VStack(alignment: .leading) {
                   Text("Super Mario Bros.")
                       .font(.title)
                       .fontWeight(.bold)
                   Text("Explore the adventure of Mario's world")
                       .foregroundColor(Color(.systemGray))
              }
               .padding(.horizontal)
               .padding(.vertical, 5)
          }
           .background(Color.white)
           .cornerRadius(5)
           .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
           .padding(.bottom, 5)
      }
   }
```

<p align="center">
 <img src="/img/Mario-bros.png" width="250">
</p>

#### 2. Dependency Injection

   _A design pattern achieved by designing your code in a way that your objects or functions receive objects that they depend on, instead of creating their own. For example, instead of creating a service around user defaults inside your view models, you should be passed an instance of such service._

   _By injecting the dependencies of an object, the responsibilities and requirements of a class or structure become more clear and more transparent. By injecting a request manager into a view controller, we understand that the view controller depends on the request manager and we can assume that the view controller is responsible for request managing and/or handling._

   _Unit testing is so much easier with dependency injection. Dependency injection makes it very easy to replace an object's dependencies with mock objects, making unit tests easier to set up and isolate behavior._

#### DI Samples

```swift
// Some Network layer
protocol NetworkProtocol {
   func load() -> String
}

final class NetworkServices: NetworkProtocol {
   func load() -> String {}
}

```
With NO DI

```swift
class ViewModelWithNoDependencyInjection {
   var services: NetworkProtocol = NetworkServices()
}
```

Initializer DI

```swift
class ViewModelWithInitializerInjection {
   private var services: NetworkProtocol
   
   init(services: NetworkProtocol) {
      self.services = services
   }

   func fetchingData() -> String {
      services.load()
   }
}
```

Property Injection

```swift
class ViewModelWithPropertyInjection {
   var services: NetworkProtocol?
}
```
Method Injection

```swift
class ViewModelWithMethodInjection {
   func fetchingData(with services: NetworkProtocol) -> String {
      services.load()
   }
}
```


#### 3. Networking

_Exchanging information via 'http' (Hypertext Transfer Protocol), one of the most used protocols_

- Concurrent
- Serial

### Build a Network layer

#### _Blueprint for network implementation (concurrent)_
```swift
protocol DataServicesProtocol {
    func fetchCoins() async throws -> [SomeData]
}
```
#### _Error handling_
```swift
enum APIError: Error {
    case invalidData
    case jsonParsinFailure
    case requesFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    case badResponse
    
    var description: String {
        switch self {
        case .invalidData: return "Invalis Data"
        case .jsonParsinFailure: return "Failed parse JSON"
        case let .requesFailed(description): return "Request failed \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid status code \(statusCode)"
        case let .unknownError(error): return "Unknown error occured \(error.localizedDescription)"
        case .badResponse: return "Bard response"
        }
    }
}
```

#### _protocol implementation_ 
```swift
final class NetworkLayer: DataServicesProtocol {
    
    func fetchData(urlString: String) async throws -> [SomeData] {
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if data.isEmpty { throw APIError.invalidData }
            
            guard response is HTTPURLResponse else {
                throw APIError.requesFailed(description: "Request Failed")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode ~= 200 else {
                throw APIError.badResponse
            }
            
            let someData = try JSONDecoder().decode([SomeData].self, from: data)
            return someData
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
            return []
        }
    }
    
}
```

#### Using : ```Result<Data, Error>``` (serial)

```swift
final class NetworkLayer {
   func fetchDataWithResult(with urlString: String, completion: @escaping(Result<[SomeData], APIError>)->Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requesFailed(description: "Request Failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([SomeData].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(coins))
                }
            } catch {
                print("DEBUG: Failed to dedcode with error: \(error)")
                completion(.failure(.jsonParsinFailure))
            }
            
        }.resume()
    }
}
```

#### 4. Pagination

_The process of breaking up a large dataset into smaller, manageable chunks or pages_

#### _Implementing pagination_
```swift
final class ViewModel: ObservableObject {
   @Published var users: [User] = []
    
    private var totalPages = 0
    private var page = 1

   // Load more users method
    func loadMoreData(with user: User) async {
      // get users last index
      let userIndex = self.users.index(self.users.endIndex, offsetBy: -1)
      // check last index id and next page is not loaded then add a page
      if userIndex == user.id, (page + 1) <= totalPages {
         page += 1
         try! await getUsers() // <- Use do-catch 
      }
    }
   
   // Fetch Users
    func getUsers() async throws { ... }

}
```

#### _Using pagination_

```swift
struct ContentView: View {
    
    @StateObject var vm = UserViewModel()
    
    var body: some View {
        List(vm.users, id: \.id) { user in
            UserView(user: user)
                .onAppear {
                    Task {
                       // load more users when the UserView row appears
                        await vm.loadMoreData(with: user)
                    }
                }
        }
        .task {
            // get users
            await vm.getUsers()
        }
    }
}
```

#### 5. Searching

#### 6. Data persisting

#### 7. async/await

#### 8. Modularization

   _Modularization is a software design technique that lets you separate an app's features into many smaller, independent modules. To achieve modularization, one must think out of the box._


<h5 style="color:gray;" >created by Israel Manzo 2021, updated on 2023</h5>
