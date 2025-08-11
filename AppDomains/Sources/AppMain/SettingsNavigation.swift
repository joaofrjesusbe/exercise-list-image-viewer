import SwiftUI
import AppCore

public struct SettingsNavigation: View {
    public init() {}
    
    public var body: some View {
        Text(L10n.tabBarTitleSettings)
    }
}

extension SettingsNavigation: NavigationRepresentable {
    
    public var navigationItem: NavigationItem {
        NavigationItem(icon: SystemImages.tabBarIconSettings, text: L10n.tabBarTitleSettings)
    }
}
