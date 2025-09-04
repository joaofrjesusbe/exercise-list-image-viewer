import SwiftUI
import AppCore

public struct DSListCell: View, Identifiable {
    @EnvironmentObject private var themer: ThemeManager
    
    public struct Item: Identifiable, Equatable {
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
    
    public let id: String
    public let item: Item
    public let didSelect: () -> Void
    
    public init(
        item: Item,
        didSelect: @escaping () -> Void
    ) {
        self.id = item.id
        self.item = item
        self.didSelect = didSelect
    }

    public var body: some View {
        Button(action: {
            didSelect()
        }, label: {
            HStack(alignment: .center) {
                DSAsyncImageSmall(url: item.icon)
                    .frame(width: 150, height: 80)
                    .background(Color(.systemGray6))
                    .padding(8)

                VStack(alignment: .leading, spacing: 8) {
                    TextBundle(item.title)
                        .foregroundColor(themer.theme.textPrimary)
                    TextBundle(item.description)
                        .foregroundColor(themer.theme.textSecondary)
                }
                Spacer(minLength: 8)
            }.padding(8)
        })
    }

    
}

#Preview {
    DSListCell(
        item: .init(id: "", title: "Title", description: "Description", icon: URL(string: "")),
        didSelect: {}
    )
    .previewWithTheme()
}
