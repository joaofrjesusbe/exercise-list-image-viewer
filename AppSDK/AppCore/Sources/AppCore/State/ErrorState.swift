import SwiftUI

public struct ErrorState {
    public let title: LocalizedKey?
    public let description: LocalizedKey
    public let icon: IconName?
    
    public init(
        title: LocalizedKey? = nil,
        description: LocalizedKey,
        icon: IconName? = nil
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}
