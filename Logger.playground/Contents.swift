import SwiftUI

struct LoggerDebug {
    
    static var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
    
    static func log(_ message: String) {
        if isProduction {
            print(message)
        }
    }
    
    static func log(_ message: String, args: CVarArg...) {
        if isProduction {
            print(String(format: message, arguments: args))
        }
    }
    
    static func logError(_ error: Error) {
        log("Error: \(error)")
    }
    
    static func debugLog(_ message: String) {
        if isProduction {
            debugPrint(message)
        }
    }
    
    static func debugLog(_ message: String, _ args: CVarArg...) {
        if isProduction {
            debugPrint(String(format: message, arguments: args))
        }
    }
}

import OSLog

final class AnotherLogger: ObservableObject {
    let logger = Logger.init(
        subsystem: "com.myapp.models",
        category: "myapp.debugging"
    )
    
    func log() {
        logger.log("Hello World!")
    }
    
    func logError(_ error: Error) {
        logger.error("Error: \(error)")
    }
}

extension View {
    func print(_ value: Any) -> Self {
        Swift.print(value)
        return self
    }
    
    func debugAction(_ action: () -> Void) -> Self {
        #if DEBUG
        action()
        #endif
        return self
    }
    
    func debugPrint(_ value: Any) -> Self {
        debugAction { Swift.print(value) }
    }
}

extension View {
    func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
        #if DEBUG
        return modifier(self)
        #else
        return self
        #endif
    }
    
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        debugModifier {
            $0.border(color, width: width)
        }
    }
    
    func debugBackground(_ color: Color = .red) -> some View {
        debugModifier {
            $0.background(color)
        }
    }
}
