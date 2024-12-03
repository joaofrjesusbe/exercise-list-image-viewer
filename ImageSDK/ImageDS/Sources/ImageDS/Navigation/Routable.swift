import SwiftUI

public protocol Routable: Hashable {
    static func homeRoute() -> Self
}

public protocol RouterNavigationStack: View {
    associatedtype Route: Routable
    
    var routes: [Route] { get set }
}
