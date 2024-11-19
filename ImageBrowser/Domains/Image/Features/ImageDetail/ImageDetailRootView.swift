import SwiftUI
import ImageDS

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
