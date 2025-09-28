import SwiftUI
import AppCore

public struct DSListCell: View, Identifiable {
    @EnvironmentObject private var themer: ThemeManager
    
    public let id: String
    public let item: DSListCellItem
    public let didSelect: () -> Void
    
    public init(
        item: DSListCellItem,
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
                DSAsyncImage(url: item.icon, maxImageSize: CGSize(width: 150, height: 80))
                    #if os(iOS)
                    .background(Color(.systemGray6))
                    #else
                    .background(Color.gray.opacity(0.1))
                    #endif
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
