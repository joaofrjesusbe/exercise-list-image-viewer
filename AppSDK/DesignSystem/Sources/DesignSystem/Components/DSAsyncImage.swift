import SwiftUI

public struct DSAsyncImage: View {
    @Environment(\.appEnvironment) private var env
    
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
                case .failure:
                    Image(systemName: SystemImages.imagePlaceholder)
                        .foregroundColor(env.theme.textPrimary)
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
    DSAsyncImage(stringUrl: "https://picsum.photos/200/300")
}
