import SwiftUI
import ImageDS
import ImageIO

struct ImageDetailFeature: Feature {
    let imageInfo: ImageInfo

    var body: some View {
        VStack {
            DSAsyncImage(stringUrl: imageInfo.largeImageURL)
            Text(MapImageInfo.toUser(imageInfo))
            Text(MapImageInfo.toLikes(imageInfo))
        }
        .navigationTitle("Image Detail")
    }
}

#Preview {
    ImageDetailFeature(imageInfo: .mock)
}
