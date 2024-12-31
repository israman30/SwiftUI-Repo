import Foundation

struct Logger {
    
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
