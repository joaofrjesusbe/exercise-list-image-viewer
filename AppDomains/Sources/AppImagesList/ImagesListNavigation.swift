import SwiftUI
import AppCore

public struct ImagesListNavigation: View, NavigationRoutable {
    @EnvironmentObject private var themer: ThemeManager
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
        .background(themer.theme.background)
        .onImageNavigate(handleNavigation)
    }
    
    public func handleNavigation(_ navType: NavigationType<Route>) {
        handleNavigationStack(stack: &routes, navType: navType)
    }
}

extension ImagesListNavigation: NavigationRepresentable {
    
    public var navigationItem: NavigationItem {
        NavigationItem(icon: SystemImages.tabBarIconListImages, text: L10n.tabBarTitleListImages)
    }
}
