import SwiftUI

public struct NavigationItem {
    public let icon: SystemImageName
    public let text: LocalizedStringResource
    
    public init(icon: SystemImageName, text: LocalizedStringResource) {
        self.icon = icon
        self.text = text
    }
}

@MainActor
public protocol NavigationRepresentable: View {
    
    var navigationItem: NavigationItem { get }
}
