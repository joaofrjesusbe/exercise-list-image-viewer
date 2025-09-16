import SwiftUI
import AppCore
import PixabayNetwork
import Nuke

public struct DSAsyncImage: View {
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
    
    @State private var platformImage: PlatformImage?
    @State private var isLoading: Bool = false
    @State private var failed: Bool = false

    public var body: some View {
        Group {
            if let image = platformImage {
                swiftUIImage(from: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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

#Preview {
    DSAsyncImage(stringUrl: "https://cdn.pixabay.com/photo/2015/11/17/13/13/puppy-1047521_150.jpg")
        .previewWithTheme()
}
