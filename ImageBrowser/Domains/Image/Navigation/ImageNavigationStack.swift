import SwiftUI
import ImageCore

struct ImageNavigationStack: RouterNavigationStack {
    @State internal var routes: [ImageRoute] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
            ImagesListFeature()
                .navigationDestination(for: ImageRoute.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                    case .detail(let imageInfo):
                        ImageDetailFeature(imageInfo: imageInfo)
                    }
                }
        }.onImageNavigate { navType in
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
