# SwiftUI-Repo

### The repository is grounded in samples and blueprints of iOS methodologies, offering insights into the development of applications, frameworks, and playgrounds.

#### Arlo's Commit Notation Cheat Sheet:
```
F!! | Feature > 8 LoC
F - | Feature <= 8 LoC
B!! | Bug Fix > 8 LoC
B - | Bug Fix <= 8 LoC
R!! | Non-provable refactoring
R - | Test-supported procedural refactoring
r - | Provable refactoring (automated, or from published recipe)
d - | Developer-visible documentation
a - | Automatic formatting/generation
e - | Environment (non-code) changes that affect development setup
t - | Test-only
_* | Known to be broken, or can't check now
note: Any commit message starting with # will be ignored
```
_source: [Arlo commit notation](https://github.com/RefactoringCombos/ArlosCommitNotation)_

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

_Employing ``` Combine``` allows us the opportunity to execute actions through subscribers during the search process._ 

```swift 
import Combine
```

_Leveraging a ViewModel, encapsulating the logic will execute the search event._

```swift
final class UserViewModel: ObservableObject  {
   @Published var users = [Users]()
   @Published var searchText = ""
   @Published var searchResult = [Users]()
   private var cancellables = Set<AnyCancellable>()

   var data = [Users]()
    
    // Filtering users implementation
   var filteredUsers: [Users] {
      if searchText.isEmpty {
         return users
      } else {
         return users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
      }
   }

   init() {
      addSubcriber()
   }

   // Adding a subcriber for filtered users
    func addSubcriber() {
        $searchText
            .receive(on: RunLoop.main)
            .sink { newUser in
                var filteredUsers: [Users] {
                    if self.searchText.isEmpty {
                        return self.users
                    } else {
                        return self.users.filter { $0.name.localizedCaseInsensitiveContains(self.searchText) }
                    }
                }
            }
            .store(in: &cancellables)   
    }
    
    // Search query method
    func searchQuery(string: String = "") {
        searchResult = string.isEmpty ? data : data.filter { $0.name.contains(string) }
    }
}
```

_Implementing searching._
```swift
struct ContentView: View {
    
   @StateObject var vm = UsersViewModel()
    
   var body: some View {
        NavigationView {
            List {
               ...
            }
            // Performing search for search text
            .searchable(text: $vm.searchText)
        }
    }
}
```

#### 6. Data persisting

_PPersisting data is achieved through various methods, such as Core Data, Realm, SwiftData, or SQLite._

_For this scenario, we will utilize native data persistence methods like Core Data._

#### _Create a Persistance layer_

```swift
struct PersistentContainer {

   static let shared = PersistentContainer()

   static var preview: PersistentContainer = {

      let result = PersistentContainer(inMemory: true)
      let viewContext = result.container.viewContext

      do {
         try viewContext.save()
      } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
        return result
   }()

   let container: NSPersistentContainer

   init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "App_name")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

}
```

#### _Implementing the saving of context when fetching data from the internet, with the ViewModel encapsulating this process.._

```swift
@Published private(set) var posts = [Post]()

// MARK: - Saving context entities
private func saveData(context: NSManagedObjectContext) {
   posts.forEach { post in
      let entity = Post(context: context)
      entity.id = Int16(post.id)
      entity.title = post.title
      entity.body = post.body
   }
        
   do {
      try context.save()
      print("SUCCESS: JSON Object saved in Cored Data")
   } catch {
      print(error.localizedDescription)
   }
}

// MARK: - `getData()` from Network Layer then saving in Core Data using `saveData(context:)`
func getData(context: NSManagedObjectContext) async {
   do {
      self.posts = try await services.fetchData()
      saveData(context: context)
   } catch {
      print("DEBUG: - Error : Some error handling - ")
   }
}
```

#### _Once saved the data whe need to Fetch the Data and display it on the View._

```swift
struct ContentView: View {

   // Get the context
   @Environment(\.managedObjectContext) var context
   // Access ViewModel
   @StateObject var vm = PostViewModel()
    // Fetching data from Core Data
   @FetchRequest(entity: Post.entity(), sortDescriptors: []) var results: FetchedResults<Post>

   var body: some View {
      if vm.posts.isEmpty {
         List(results) {
            // Render from context
            RowView()
               .onAppear {
                  Task {
                     try await getData(context: context)
                  }
               }
         }
      } else {
         List(vm.posts) {
            // Fetch data or display a message
         }
      }
   }
}
```
#### 7. async/await

#### 8. Modularization

   _Modularization is a software design technique that lets you separate an app's features into many smaller, independent modules. To achieve modularization, one must think out of the box._

#### 9. Hex color converter extension

_This extesion takes a hex number string and converte it on ```UIColor```_

```swift
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        switch length {
        case 6:
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        case 8:
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        default:
            return nil
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // Creating custom color methods
    static func  mainColor() -> UIColor? {
        return UIColor(hex: "fcfbf0")
    }

    static func custom(hex colorString: String) -> UIColor {
        return UIColor(hex: colorString)
    }
}

let someView.backgrounColor = UIColor(hex: "#fff")
let anotherView.foregroundColor = UIColor.mainColor()
let oneMoreView.backgroundColor = UIColor.custom(hex: "#Fe343F")
```

<h5 style="color:gray;" >created by Israel Manzo 2021, updated on 2023</h5>
