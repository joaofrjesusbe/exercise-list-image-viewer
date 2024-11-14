import Foundation

public enum NetworkError: Error, CustomDebugStringConvertible {
    case deallocated
    case urlMalform
    case general
    case invalidPage(Int)
    
    public var debugDescription: String {
        switch self {
        case .deallocated:
            return "Network connection was deallocated"
        case .urlMalform:
            return "URL malformed"
        case .general:
            return "General network error"
        case .invalidPage(let page):
            return "Invalid page number: \(page)"
        }
    }
}
