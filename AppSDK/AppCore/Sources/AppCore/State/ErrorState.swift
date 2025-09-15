import SwiftUI

public struct ErrorState: Equatable, Sendable {
    public let title: LocalizedStringResource?
    public let description: LocalizedStringResource
    public let icon: Image?
    
    public init(
        title: LocalizedStringResource? = nil,
        description: LocalizedStringResource,
        icon: Image? = nil
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}
