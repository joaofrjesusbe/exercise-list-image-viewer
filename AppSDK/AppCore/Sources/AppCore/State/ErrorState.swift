import SwiftUI

public struct ErrorState {
    public let title: LocalizedString?
    public let description: LocalizedString
    public let icon: Image?
    
    public init(
        title: LocalizedString? = nil,
        description: LocalizedString,
        icon: Image? = nil
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}
