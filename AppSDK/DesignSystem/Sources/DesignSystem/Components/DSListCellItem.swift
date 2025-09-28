import SwiftUI

public struct DSListCellItem: Identifiable, Equatable {
    public let id: String
    public let title: LocalizedStringResource
    public let description: LocalizedStringResource
    public let icon: URL?
    
    public init(
        id: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        icon: URL?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
    }
}
