import SwiftUI
import DomainList
import PixbayNetwork

@main
struct ImageBrowserApp: App {
    
    var body: some Scene {
        WindowGroup {
            ImageNavigationStack()
        }
    }
}
