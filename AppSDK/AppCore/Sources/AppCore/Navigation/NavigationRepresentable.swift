import SwiftUI

public struct NavigationItem {
    public let icon: SystemImageName
    public let text: LocalizedKey
    
    public init(icon: SystemImageName, text: LocalizedKey) {
        self.icon = icon
        self.text = text
    }
}

@MainActor
public protocol NavigationRepresentable: View {
    
    var navigationItem: NavigationItem { get }
}
