import SwiftUI
import AppGroup

public struct ImagesListNavigation: View, NavigationRoutable {
    @State public private(set) var routes: [ImageRoute] = []
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $routes) {
            ImagesListRootView(viewModel: ImagesListDI.createImageListViewModel())
                .navigationDestination(for: ImageRoute.self) { route in
                    switch route {
                    case .detail(let index):
                        ImagesListDetailRootView(imageInfo: ImagesListDI.getImageDetail(index: index))
                    }
                }
        }        
        .onImageNavigate(handleNavigation)
    }
    
    public func handleNavigation(_ navType: NavigationType<Route>) {
        handleNavigationStack(stack: &routes, navType: navType)
    }
}

extension ImagesListNavigation: NavigationRepresentable {
    
    public var navigationItem: NavigationItem {
        NavigationItem(icon: SystemImages.tabBarIconListImages, text: L10n.listTitle)
    }
}
