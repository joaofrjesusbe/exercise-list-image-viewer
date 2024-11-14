import Foundation

public enum NavigationType<Route: Hashable>: Hashable {
    case push(Route)
    case unwind(Route)
}
