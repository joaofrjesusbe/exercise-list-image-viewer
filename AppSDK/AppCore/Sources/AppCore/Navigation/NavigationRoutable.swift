import SwiftUI

@MainActor
public protocol NavigationRoutable {
    associatedtype Route: Routable
    
    var routes: [Route] { get set }
    
    func handleNavigation(_ navType: NavigationType<Route>)
}

public extension NavigationRoutable {
    
    func handleNavigationStack(stack: inout [Route], navType: NavigationType<Route>) {
        switch navType {
        case .push(let route):
            stack.append(route)
        case .rewind(let route):
            if route.isHomeRoute {
                stack = []
            } else {
                guard let index = stack.firstIndex(where: { $0 == route })  else { return }
                stack = Array(stack.prefix(upTo: index + 1))
            }
        case .back:
            stack.removeLast()
        case .forwardAndReplace(let route):
            stack.removeLast()
            stack.append(route)
        }
    }
}
