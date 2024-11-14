import SwiftUI
import ImageDS

struct ImageDetailFeature: Feature {
    let imageInfo: ImageInfo

    var body: some View {
        VStack {
            DSAsyncImage(stringUrl: imageInfo.largeImageURL)
            Text("User: \(imageInfo.user)")
            Text("Likes: \(imageInfo.likes)")
        }
        .navigationTitle("Image Detail")
    }
}

#Preview {
    ImageDetailFeature(imageInfo: .mock)
}
