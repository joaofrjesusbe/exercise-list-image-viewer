import SwiftUI
import DesignSystem
import PixbayNetwork
import FactoryKit

struct ImagesListDetailRootView: View {
    @Injected(\.imageInfoUIAdapter) private var adapter
    let imageInfo: ImageInfo

    var body: some View {
        VStack {
            DSAsyncImage(stringUrl: imageInfo.largeImageURL)
            Text(adapter.toUserString(imageInfo))
            Text(adapter.toLikesString(imageInfo))
        }
        .navigationTitle(L10n.detailTitle.asLocalizedKey)
    }
}

#Preview {
    ImagesListDetailRootView(imageInfo: .mock)
}
