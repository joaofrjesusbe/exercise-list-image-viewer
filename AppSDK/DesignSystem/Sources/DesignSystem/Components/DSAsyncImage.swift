import SwiftUI
import AppCore
import PixabayNetwork
import Nuke

public struct DSAsyncImage: View {
    @EnvironmentObject private var themer: ThemeManager
    
    public let url: URL?
    private let maxImageSize: CGSize?
    
    public init(url: URL?, maxImageSize: CGSize? = nil) {
        self.url = url
        self.maxImageSize = maxImageSize
    }
    
    public init(stringUrl: String?, maxImageSize: CGSize? = nil) {
        if let stringUrl {
            url = URL(string: stringUrl)
        } else {
            url = nil
        }
        self.maxImageSize = maxImageSize
    }
    
    @State private var platformImage: PlatformImage?
    @State private var isLoading: Bool = false
    @State private var failed: Bool = false

    @ViewBuilder
    public var body: some View {
        Group {
            if let image = platformImage {
                swiftUIImage(from: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .optionalMaxFrame(maxImageSize)
            } else if isLoading {
                ProgressView()
            } else if failed || url == nil {
                Image(systemName: SystemImages.imagePlaceholder)
                    .foregroundColor(themer.theme.textPrimary)
            } else {
                ProgressView()
            }
        }
        .task(id: url) {
            guard let url else { return }
            isLoading = true
            failed = false
            do {
                let loader = Container.shared.imageLoader()
                let img = try await loader.image(for: url)
                platformImage = img
            } catch {
                failed = true
            }
            isLoading = false
        }
    }

    private func swiftUIImage(from platform: PlatformImage) -> Image {
        #if canImport(UIKit)
        return Image(uiImage: platform)
        #elseif canImport(AppKit)
        return Image(nsImage: platform)
        #else
        return Image(systemName: SystemImages.imagePlaceholxder)
        #endif
    }
}

private extension View {
    @ViewBuilder
    func optionalMaxFrame(_ size: CGSize?) -> some View {
        if let size {
            self.frame(maxWidth: size.width, maxHeight: size.height)
        } else {
            self
        }
    }
}

#Preview {
    DSAsyncImage(
        stringUrl: "https://cdn.pixabay.com/photo/2015/11/17/13/13/puppy-1047521_150.jpg",
        maxImageSize: .init(width: 300, height: 200)
    )
    .previewWithTheme()
}
