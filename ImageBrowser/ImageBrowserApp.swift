import SwiftUI
import AppImagesList

@main
struct ImageBrowserApp: App {
    
    var body: some Scene {
        WindowGroup {
            ImagesListNavigation()
        }
    }
}
