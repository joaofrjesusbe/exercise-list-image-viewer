import Foundation

public enum NavigationType<Route: Routable>: Hashable {
    case push(Route)
    case unwind(Route)
}
