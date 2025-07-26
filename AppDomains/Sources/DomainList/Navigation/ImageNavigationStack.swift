import SwiftUI
import AppCore

public struct ImageNavigationStack: View, NavigationRoutable {
    @State public var routes: [ImageRoute] = []
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $routes) {
            DomainListDI.createImageList()
                .navigationDestination(for: ImageRoute.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                    case .detail(let imageInfo):
                        DomainListDI.createImageDetail(detail: imageInfo)
                    }
                }
        }
        .onImageNavigate(handleNavigation)
    }
    
    public func handleNavigation(_ navType: NavigationType<Route>) {
        handleNavigationStack(stack: &routes, navType: navType)
    }
}
