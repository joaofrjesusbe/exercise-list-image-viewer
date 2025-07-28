import SwiftUI
import AppImagesList
import AppCore

@main
struct ImageBrowserApp: App {
    @Environment(\.appEnvironment) var appEnvironment
    
    var body: some Scene {
        WindowGroup {
            ImagesListNavigation()
        }
    }
}
