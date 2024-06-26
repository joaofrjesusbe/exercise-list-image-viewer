import SwiftUI

struct MainNavigationView: View {
    let coordinator: MainCoordinator

    var body: some View {
        NavigationStack(path: Bindable(coordinator).viewPath) {
            coordinator.listImageFeature.rootView
            .navigationDestination(for: ImageInfoUI.self) { image in
                ImageDetailRootView(imageInfo: image)
            }
        }
    }
}

