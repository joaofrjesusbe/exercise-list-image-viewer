import Foundation

public struct ConsoleLogger: Logger {
    public var options: [LogOptions]
    
    public init(options: [LogOptions] = LogOptions.common) {
        self.options = options
    }
    
    private func logOutput(icon: String, level: String, message: String) {
        #if DEBUG
        print("\(icon) \(level) - \(message)\n")
        #endif
    }
    
    public func debug(_ message: String) {
        if options.contains(.debug) {
            logOutput(icon: "🛠️", level: "DEBUG", message: message)
        }
    }
    
    public func network(_ message: String) {
        if options.contains(.network) {
            logOutput(icon: "🌐", level: "NETWORK", message: message)
        }
    }

    public func info(_ message: String) {
        if options.contains(.info) {
            logOutput(icon: "ℹ️", level: "INFO", message: message)
        }
    }

    public func warning(_ message: String) {
        if options.contains(.warning) {
            logOutput(icon: "⚠️", level: "WARNING", message: message)
        }
    }

    public func error(_ message: String) {
        if options.contains(.error) {
            logOutput(icon: "🟥", level: "ERROR", message: message)
        }
    }
}
