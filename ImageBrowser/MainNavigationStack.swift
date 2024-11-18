import SwiftUI
import ImageCore

struct MainNavigationStack<RootFeature: Feature>: View {
    @State private var routes: [Route] = []
    @ViewBuilder public var rootFeature: () -> RootFeature
    
    var body: some View {
        NavigationStack(path: $routes) {
            rootFeature()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        rootFeature()
                    case .detail(let imageInfo):
                        ImageDetailFeature(imageInfo: imageInfo)
                    }
                }
        }.onNavigate { navType in
            switch navType {
            case .push(let route):
                routes.append(route)
            case .unwind(let route):
                
                if route == .home {
                    routes = []
                } else {
                    guard let index = routes.firstIndex(where: { $0 == route })  else { return }
                    routes = Array(routes.prefix(upTo: index + 1))
                }
            }
        }
    }
}
