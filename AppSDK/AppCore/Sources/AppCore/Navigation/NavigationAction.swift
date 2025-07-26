import Foundation

public struct NavigateAction<Route: Routable> {
    public typealias Action = (NavigationType<Route>) -> Void
    
    public let action: Action
    
    public init(action: @escaping Action) {
        self.action = action
    }
    
    public func callAsFunction(_ navigationType: NavigationType<Route>) {
        action(navigationType)
    }
}
