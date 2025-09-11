import Foundation

public enum LogOptions: Int, CaseIterable, Sendable {
    case debug = 0
    case network
    case info
    case warning
    case error
    
    public static var maintainer: [LogOptions] {
        [.warning, .error]
    }
    
    public static var common: [LogOptions] {
        [.network, .info, .warning, .error]
    }
    
    public static var verbose: [LogOptions] {
        [.debug, .network, .info, .warning, .error]
    }
}

public protocol Logger: Sendable {
    
    func debug(_ message: String)
    
    func network(_ message: String)
    
    func info(_ message: String)
    
    func warning(_ message: String)
    
    func error(_ message: String)
}

public extension Logger {
    
    func trace(file: String = #file, function: StaticString = #function) -> Void {
        self.debug("\(file.components(separatedBy: "/").last ?? "") - \(function)")
    }
    
    func debug(json data: Data) {
        #if DEBUG
        let jsonString = prettyPrintedJSON(from: data)
        debug("json:\n\(jsonString)")
        #endif
    }
    
    func network(json data: Data) {
        #if DEBUG
        let jsonString = prettyPrintedJSON(from: data)
        network("json:\n\(jsonString)")
        #endif
    }
    
    func prettyPrintedJSON(from data: Data) -> String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(decoding: prettyData, as: UTF8.self)
        } catch {
            return "Invalid JSON data: \(error.localizedDescription)"
        }
    }
}
