import Foundation

public enum NavigationType<Route: Routable>: Hashable, CustomDebugStringConvertible {
    case push(Route)
    case rewind(Route)
    case back
    case home
    case forwardAndReplace(Route)
    
    public var debugDescription: String {
        switch self {
        case .push(let route):
            return "Navigate.push(\(route))"
        case .rewind(let route):
            return "Navigate.rewind(\(route))"
        case .back:
            return "Navigate.back"
        case .home:
            return "Navigate.home"
        case .forwardAndReplace(let route):
            return "Navigate.forwardAndReplace(\(route))"
        }
    }
}
