import UIKit

// MARK: --- Data flow in SwiftUI ---
/** 
 - `@State` variables are owned by the view. SwiftUI ensures that this view is updated whenever the value of the state variable changes.
    Apple encourages you to mark these `private` to emphasize that a `@State` variable is owned and managed by that view specifically.
    `@State` binding variables are only in memory for the lifetime of the view.
 
 - `@Binding `declares dependency on a `@State` variable owned by another view, which uses the $ prefix to pass a binding to this state variable to another view.
    In the receiving view, `@Binding` variable is a reference to the data, so it doesn't need an initial value. So, with @Binding, you create a property similar to a state property,
    but with the data stored elsewhere, in a state property or an observable object of an ancestor view.
 
 - `@ObservedObject` declares dependency on a reference type that conforms to the ObservableObject protocol.
    It implements an `objectWillChange` property to publish changes to its data. The class can define one or more `@Published` properties.
 
 - `@EnvironmentObject` declares dependency on some shared data — data that's visible to all views in the app.
    It's a convenient way to pass data indirectly, instead of passing data from parent view to child to grandchild, especially if the child view doesn't need it.
*/

// MARK: --- ObservableObject, ObservedObject, StateObject, and EnvironmentObject ---

// MARK: ObservableObject
/**
 The `ObservableObject` protocol enables the creation of objects that automatically notify their subscribers about any changes.
 By adopting this protocol and using the `@Published` property wrapper, you can effortlessly make certain properties of an object observable.
 
 >  `@Published` : It is a property wrapper in Swift that automatically broadcasts any changes made to a property to its subscribers.
    It is commonly used with the `ObservableObject` protocol to create reactive and observable objects.
    When the value of a property marked with `@Published` changes, the object notifies its subscribers, enabling them to react to the updates.
 */

// MARK: ObservedObject
/**
 - Used to observe and respond to changes in an external object that conforms to the `ObservableObject` protocol.
 - The external object is typically created and owned outside of the SwiftUI view hierarchy.
 - The view automatically updates when the observed object changes.
 - Suitable when the object is shared among multiple views.
 
    `ObservedObject` is a property wrapper that is used within SwiftUI views to observe changes to an `ObservableObject`.
    When a property of a view is marked with `@ObservedObject`, SwiftUI automatically subscribes to changes in the object and the view is updated whenever the object's `@Published` properties change.
 */

// MARK: StateObject
/**
 -  Used to create and manage an object that conforms to the `ObservableObject` protocol within a specific view.
 -  The object is owned and managed by the view itself.
 -  The view automatically updates when the state object changes.
 -  Suitable when the object is specific to a single view or its subviews.
 
    The `StateObject` property wrapper manages the lifecycle of reference-type objects within a SwiftUI view.
    It automatically creates and preserves the object across view updates, ensuring its state persists consistently.
 */

// MARK: EnvironmentObject
/**
 -  Used to share an object that conforms to the `ObservableObject` protocol across multiple views in the view hierarchy.
 -  The object is typically created and owned outside of the view hierarchy, but it is injected into the environment.
 -  Views can access the shared object using the `@EnvironmentObject` property wrapper.
 -  Suitable when the object needs to be shared among multiple unrelated views, without explicitly passing it down the hierarchy.
 
    The `@EnvironmentObjec`t property wrapper allows you to share data across multiple views in a SwiftUI hierarchy.
    It eliminates the need for manual passing of data through view hierarchies and provides a global approach to data sharing.
    It allows you to inject an object at the top level of the view hierarchy and access it from any view below that level.
 */

/**
 `Conclusion`
    `ObservableObject`
        It’s is base for create class for register objects that automatically notify their subscribers about any changes by control from about property `@Published `
        and work with Object `(ObservedObject, StateObject, and EnvironmentObject)`
 
    `In summary ObservedObject, StateObject, and EnvironmentObject:`
         -  `ObservedObject` is used for external objects that conform to `ObservableObject`.
         -  `StateObject` is used for creating and managing objects within a specific view.
         -  `EnvironmentObject` is used for sharing objects across multiple views in the hierarchy.
 
    The choice between these depends on the specific use case, the ownership and lifetime of the object, and the scope of sharing the object within the view hierarchy.
 */
