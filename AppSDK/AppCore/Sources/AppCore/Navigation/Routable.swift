import Foundation

public protocol Routable: Hashable, Equatable, CustomDebugStringConvertible {

    static func homeRoute() -> Self
}

public extension Routable {
    var isHomeRoute: Bool {
        Self.homeRoute() == self
    }
}
