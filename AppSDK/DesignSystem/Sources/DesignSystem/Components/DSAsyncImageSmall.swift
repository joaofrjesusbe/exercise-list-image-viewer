import SwiftUI
import AppCore

public struct DSAsyncImageSmall: View {
    @EnvironmentObject private var themer: ThemeManager
    
    public let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public init(stringUrl: String?) {
        if let stringUrl {
            url = URL(string: stringUrl)
        } else {
            url = nil
        }
    }
    
    public var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150, maxHeight: 80)
                case .failure:
                    Image(systemName: SystemImages.imagePlaceholder)
                        .foregroundColor(themer.theme.textPrimary)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
        }
    }
}

#Preview {
    DSAsyncImageSmall(stringUrl: "https://picsum.photos/200/300")
}
