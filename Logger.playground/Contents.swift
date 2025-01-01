import Foundation

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

let log = AnotherLogger()
log.log()
