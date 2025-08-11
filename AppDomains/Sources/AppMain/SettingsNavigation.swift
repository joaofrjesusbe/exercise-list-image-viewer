import SwiftUI
import AppCore

public struct SettingsNavigation: View {
    public init() {}
    
    public var body: some View {
        Text("Settings")
    }
}

extension SettingsNavigation: NavigationRepresentable {
    
    public var navigationItem: NavigationItem {
        NavigationItem(icon: "gearshape", text: "Settings")
    }
}
