import Foundation

public enum NetworkError: Error, CustomDebugStringConvertible {
    case badRequest
    case general
    case badStatus(Int, Data)
    case invalidPage(Int)
    
    public var debugDescription: String {
        switch self {
        case .badRequest:
            return "URL badRequest"
        case .badStatus(let code, _):
            return "HTTP error \(code)."
        case .general:
            return "General network error"
        case .invalidPage(let page):
            return "Invalid page number: \(page)"
        }
    }
}
