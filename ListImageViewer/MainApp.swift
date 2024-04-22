import SwiftUI

@main
struct MainApp: App {
    @State private var coordinator = MainCoordinator()

    var body: some Scene {
       WindowGroup {
           MainNavigationView(coordinator: coordinator)
       }
    }
}
