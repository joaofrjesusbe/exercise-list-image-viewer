import SwiftUI
import ImageCore

struct MainNavigationStack: RouterNavigationStack {
    @State internal var routes: [MainRoute] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
            ImagesListFeature()
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                    case .detail(let imageInfo):
                        ImageDetailFeature(imageInfo: imageInfo)
                    }
                }
        }.onMainNavigate { navType in
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
