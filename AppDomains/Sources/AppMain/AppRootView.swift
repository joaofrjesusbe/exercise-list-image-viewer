import SwiftUI
import AppCore
import AppImagesList

public struct AppRootView: View {
    @EnvironmentObject private var themer: ThemeManager
    
    @State private var tabSelection = 0
    
    public init() {}
    
    public var body: some View {
        MainNavigation(
            tabs: [
                ImagesListNavigation().eraseToAnyNavigation(),
                SettingsView().eraseToAnyNavigation()
            ],
            selection: $tabSelection
        )
        .background(themer.theme.background)
        .syncSystemTheme()
    }
}
