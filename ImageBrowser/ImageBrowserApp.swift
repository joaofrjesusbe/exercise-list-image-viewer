import SwiftUI
import AppImagesList
import AppCore
import AppMain

@main
struct ImageBrowserApp: App {
    @Environment(\.appEnvironment) var appEnvironment
    
    var body: some Scene {
        WindowGroup {
            MainNavigation(tabs: [
                ImagesListNavigation().eraseToAnyNavigation(),
                SettingsNavigation().eraseToAnyNavigation()
            ])
        }
    }
}
