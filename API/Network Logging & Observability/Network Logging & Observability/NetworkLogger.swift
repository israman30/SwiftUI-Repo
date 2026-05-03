//
//  NetworkLogger.swift
//  Network Logging & Observability
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation
import OSLog

enum LogLevel: String {
    case request = "REQUEST"
    case response = "RESPONSE"
    case success = "SUCCESS"
    case error = "ERROR"
    case warning = "WARNING"
}

class NetworkLogger {
    static let shared = NetworkLogger()
    private init() { }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "app", category: "Network")
    
    func logRequest(_ url: URL?, method: String = "GET", header: [String:String]? = nil) {
        guard let url = url else {
            log(level: .warning, message: "Attempted request with nil URL")
            return
        }
        
        var output = """
        \(separator())
        \(LogLevel.request.rawValue)
        URL: \(url.absoluteString)
        Method: \(method)
        """
        
        if let header, !header.isEmpty {
            output += "\nHeaders : \(header)"
        }
        
        output += "\n\(separator())"
        log(level: .request, message: output)
        
    }
    
    func logResponse(_ response: URLResponse?, data: Data?, url: URL?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            log(level: .warning, message: "Non-HTTP response received for: \(url?.absoluteString ?? "unknown")")
            return
        }
        let statusCode = httpResponse.statusCode
        let level: LogLevel = (200...299).contains(statusCode) ? .success : .error
        
        var output = """
        \(separator())
        \(LogLevel.request.rawValue)
        URL: \(url?.absoluteString ?? "unknown")
        Status: \(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)
        """
        
        if let data = data {
            output += "\nSize: \(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file))"
            output += "\nBody: \n\(prettyPrint(data))"
        }
        
        output += "\n\(separator())"
        log(level: level, message: output)
    }
    
    func logError(_ error: Error, url: URL?) {
        let output = """
        \(separator())
        \(LogLevel.error.rawValue)
        URL: \(url?.absoluteString ?? "unknown")
        Error: \(error.localizedDescription)
        Type: \(type(of: error))
        """
        log(level: .error, message: output)
    }
    
    func logDecoder<T: Decodable>(_ type: T.Type, count: Int? = nil) {
        var message = "Decoded -> \(String(describing: type))"
        if let count {
            message += " (\(count) items)"
        }
        log(level: .success, message: message)
    }
    
    private func log(level: LogLevel, message: String) {
        #if DEBUG
        print(message)
        #endif
        
        switch level {
        case .error:
            logger.error("\(message)")
        case .warning:
            logger.warning("\(message)")
        default:
            logger.info("\(message)")
        }
    }
    
    private func separator() -> String {
        String(repeating: "-", count: 52)
    }
    
    private func prettyPrint(_ data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data),
              let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let string = String(data: pretty, encoding: .utf8) else {
            return String(data: data, encoding: .utf8) ?? "<unreadable>"
        }
        let limit = 2000
        return string.count > limit ? String(string.prefix(limit)) + "\n... [truncated \(string.count - limit) chars]" : string
    }
}
