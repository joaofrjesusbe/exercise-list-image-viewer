import SwiftUI

public struct DSListCell: View, Identifiable {
    public struct Input: Identifiable {
        public let id: String
        public let title: String
        public let description: String
        public let icon: URL?
        
        public init(
            id: String,
            title: String,
            description: String,
            icon: URL?
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.icon = icon
        }
    }
    
    public let id: String
    public let input: Input
    public let didSelect: () -> Void
    
    public init(
        input: Input,
        didSelect: @escaping () -> Void
    ) {
        self.id = input.id
        self.input = input
        self.didSelect = didSelect
    }

    public var body: some View {
        Button(action: {
            didSelect()
        }, label: {
            HStack(alignment: .center) {
                DSAsyncImageSmall(url: input.icon)
                    .frame(width: 150, height: 80)
                    .background(Color(.systemGray6))
                    .padding(8)

                VStack(alignment: .leading, spacing: 8) {
                    Text(input.title)
                    Text(input.description)
                }
                Spacer(minLength: 8)
            }.padding(8)
        })
    }

    
}

#Preview {
    DSListCell(
        input: .init(id: "", title: "Title", description: "Description", icon: URL(string: "")),
        didSelect: {}
    )
}
