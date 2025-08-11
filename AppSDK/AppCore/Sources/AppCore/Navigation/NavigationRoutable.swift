import SwiftUI

@MainActor
public protocol NavigationRoutable {
    associatedtype Route: Routable
    
    var routes: [Route] { get }
    
    func handleNavigation(_ navType: NavigationType<Route>)
}

public extension NavigationRoutable {
    
    func handleNavigationStack(stack: inout [Route], navType: NavigationType<Route>) {
        switch navType {
        case .push(let route):
            stack.append(route)
            
        case .rewind(let route):
            guard let i = stack.firstIndex(of: route) else { return }
            // mutate in place (don’t replace whole array)
            if i + 1 < stack.count {
                stack.removeSubrange((i + 1)..<stack.count)
            }
            
        case .back:
            if !stack.isEmpty { stack.removeLast() }
            
        case .home:
            stack.removeAll()
            
        case .forwardAndReplace(let route):
            if !stack.isEmpty { stack.removeLast() }
            stack.append(route)
        }
    }
}
