import SwiftUI

public struct ErrorState {
    public let title: LocalizedKey?
    public let description: LocalizedKey
    public let icon: Image?
    
    public init(
        title: LocalizedKey? = nil,
        description: LocalizedKey,
        icon: Image? = nil
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}
