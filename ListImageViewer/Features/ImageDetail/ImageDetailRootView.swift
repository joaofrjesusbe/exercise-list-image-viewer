import SwiftUI

struct ImageDetailRootView: View {
    let imageInfo: ImageInfoUI

    var body: some View {
        VStack {
            asyncImage

            Text(imageInfo.user)
            Text(imageInfo.likes)
        }
        .navigationTitle("Image Detail")
    }

    var asyncImage: some View {
        AsyncImage(url: imageInfo.detail) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        .background(Color(.systemGray6))
        .padding(8)
    }
}

#Preview {
    ImageDetailRootView(imageInfo: .mock)
}
