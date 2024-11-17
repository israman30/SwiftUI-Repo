import SwiftUI
import PlaygroundSupport

// MARK: - @Entry -
/**
 The `@Entry` macro in SwiftUI allows you to define custom environment values without writing boilerplate code. While introduced in Xcode 16, you can use it from `iOS 13 and up` since it’s a Swift Macro that generates backward-compatible code.
 The new macro can be used for environment values, as well as for transaction, container, and focused values. In this article, we’ll be focusing on environment values only.
 */

class ColorTheme {
    var primaryColor: Color
    
    init(primaryColor: Color) {
        self.primaryColor = primaryColor
    }
}

extension EnvironmentValues {
    @Entry var colorTheme: ColorTheme = .init(primaryColor: .accentColor)
}

struct ThemeView: View {
    @Environment(\.colorTheme) private var colorTheme
    var body: some View {
        Text("Hello, World!")
            .foregroundStyle(colorTheme.primaryColor)
    }
}

// Another sample of @Emtry
enum UserState {
    case loggedIn
    case loggedOut
    case newUser
    
    init (isLoggedIn: Bool) {
        switch isLoggedIn {
        case true:
            self = .loggedIn
        case false:
            self = .loggedOut
        }
    }
}

// Declare environment value
extension EnvironmentValues {
    @Entry var userState: UserState = .loggedOut
}

struct ContentView: View {
    var body: some View {
        Text("ContentView")
    }
}
/// `@main`
struct MyApp: App {
    @State var userState: UserState = .loggedOut
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.userState, userState)
        }
    }
}
