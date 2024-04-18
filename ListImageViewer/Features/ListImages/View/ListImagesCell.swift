import SwiftUI

struct ListImagesCell: View {
    let imageInfo: ImageInfoUI
    let index: Int
    let didSelect: (ImageInfoUI) -> Void

    var body: some View {
        Button(action: {
            didSelect(imageInfo)
        }, label: {
            HStack(alignment: .center) {
                AsyncImage(url: imageInfo.url) { phase in
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


                VStack(alignment: .leading, spacing: 8) {
                    Text("Cell: \(index)")
                    Text("Likes: \(imageInfo.likes)")
                }
                Spacer(minLength: 8)
            }.padding(8)
        })
    }
}

#Preview {
    ListImagesCell(
        imageInfo: .mock,
        index: 0,
        didSelect: {_ in }
    )
}
