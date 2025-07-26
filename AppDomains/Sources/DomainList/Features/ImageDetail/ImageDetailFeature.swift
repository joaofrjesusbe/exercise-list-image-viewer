import SwiftUI
import DesignSystem
import PixbayNetwork

struct ImageDetailFeature: View {
    let imageInfo: ImageInfo

    var body: some View {
        VStack {
            DSAsyncImage(stringUrl: imageInfo.largeImageURL)
            Text(ImageInfoAdapter.toUser(imageInfo))
            Text(ImageInfoAdapter.toLikes(imageInfo))
        }
        .navigationTitle("Image Detail")
    }
}

#Preview {
    ImageDetailFeature(imageInfo: .mock)
}
