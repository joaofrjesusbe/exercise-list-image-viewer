import Foundation

public enum NetworkError: Error, CustomDebugStringConvertible {
    case urlMalform
    case general
    case invalidPage(Int)
    
    public var debugDescription: String {
        switch self {
        case .urlMalform:
            return "URL malformed"
        case .general:
            return "General network error"
        case .invalidPage(let page):
            return "Invalid page number: \(page)"
        }
    }
}
