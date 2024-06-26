import SwiftUI

struct ListImagesCell: View {
    let imageInfo: ImageInfoUI
    let didSelect: (ImageInfoUI) -> Void

    var body: some View {
        Button(action: {
            didSelect(imageInfo)
        }, label: {
            HStack(alignment: .center) {
                asyncImage

                VStack(alignment: .leading, spacing: 8) {
                    Text(imageInfo.user)
                    Text(imageInfo.likes)
                }
                Spacer(minLength: 8)
            }.padding(8)
        })
    }

    var asyncImage: some View {
        AsyncImage(url: imageInfo.preview) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 150, maxHeight: 80)
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 150, height: 80)
        .background(Color(.systemGray6))
        .padding(8)
    }
}

#Preview {
    ListImagesCell(
        imageInfo: .mock,
        didSelect: {_ in }
    )
}
