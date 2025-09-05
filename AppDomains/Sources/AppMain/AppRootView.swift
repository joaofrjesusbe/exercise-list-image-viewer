import SwiftUI
import AppGroup
import AppImagesList

public struct AppRootView: View {
    @EnvironmentObject private var themer: ThemeManager
    
    @Binding private var tabSelection: Int
    
    public init(tabSelection: Binding<Int>) {
        _tabSelection = tabSelection
    }
    
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
