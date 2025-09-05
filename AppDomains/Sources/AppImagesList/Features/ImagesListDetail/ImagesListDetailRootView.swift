import SwiftUI
import AppGroup

struct ImagesListDetailRootView: View {
    @Injected(\.imageInfoUIAdapter) private var adapter
    let imageInfo: ImageInfo

    var body: some View {
        VStack {
            DSAsyncImage(stringUrl: imageInfo.largeImageURL)
            TextBundle(adapter.toUserString(imageInfo))
            TextBundle(adapter.toLikesString(imageInfo))
        }
        .navigationTitle(L10n.detailTitle)
    }
}


struct ImagesListDetailRootView_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        ImagesListDetailRootView(imageInfo: .mock)
    }
}
