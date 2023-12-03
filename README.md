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

<p align="center">
 <img src="/img/Mario-bros.png" width="250">
</p>

2. Dependency Injection

   _A design pattern achieved by designing your code in a way that your objects or functions receive objects that they depend on, instead of creating their own. For example, instead of creating a service around user defaults inside your view models, you should be passed an instance of such service._

   _By injecting the dependencies of an object, the responsibilities and requirements of a class or structure become more clear and more transparent. By injecting a request manager into a view controller, we understand that the view controller depends on the request manager and we can assume that the view controller is responsible for request managing and/or handling._

   _Unit testing is so much easier with dependency injection. Dependency injection makes it very easy to replace an object's dependencies with mock objects, making unit tests easier to set up and isolate behavior._

3. Networking

4. Pagination

5. Searching

6. Data persisting


7. async/await

8. Modularization

   _Modularization is a software design technique that lets you separate an app's features into many smaller, independent modules. To achieve modularization, one must think out of the box._


_created by Israel Manzo 2021, updated on 2023_
