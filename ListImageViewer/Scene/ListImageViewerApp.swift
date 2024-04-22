import SwiftUI

@main
struct ListImageViewerApp: App {
    @State var coordinator = MainCoordinator()

    // MARK: Scenes

    var body: some Scene {
        WindowGroup {
            HomeCoordinatorView(coordinator: coordinator)
        }
    }
}
