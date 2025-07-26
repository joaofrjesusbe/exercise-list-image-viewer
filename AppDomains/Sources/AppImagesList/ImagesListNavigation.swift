import SwiftUI
import AppCore

public struct ImagesListNavigation: View, NavigationRoutable {
    @State public var routes: [ImageRoute] = []
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $routes) {
            ImagesListRootView(viewModel: ImagesListDI.createImageListViewModel())
                .navigationDestination(for: ImageRoute.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                    case .detail(let imageInfo):
                        ImagesListDetailRootView(imageInfo: imageInfo)
                    }
                }
        }
        .onImageNavigate(handleNavigation)
    }
    
    public func handleNavigation(_ navType: NavigationType<Route>) {
        handleNavigationStack(stack: &routes, navType: navType)
    }
}
