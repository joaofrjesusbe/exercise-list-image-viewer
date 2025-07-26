import SwiftUI
import DesignSystem
import PixbayNetwork

struct ImagesListDetailRootView: View {
    let imageInfo: ImageInfo

    var body: some View {
        VStack {
            DSAsyncImage(stringUrl: imageInfo.largeImageURL)
            Text(ImagesInfoUIAdapter.toUserString(imageInfo))
            Text(ImagesInfoUIAdapter.toLikesString(imageInfo))
        }
        .navigationTitle("Image Detail")
    }
}

#Preview {
    ImagesListDetailRootView(imageInfo: .mock)
}
