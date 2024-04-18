import SwiftUI

struct ListImagesView: View {
    let items: [ImageInfoUI]
    let onItemAppear: (Int) -> Void
    let didSelect: (ImageInfoUI) -> Void

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(
                    Array(items.enumerated()),
                    id: \.element)
                { index, element in

                    ListImagesCell(
                        imageInfo: element,
                        index: index,
                        didSelect: didSelect
                    )
                    .onAppear {
                        onItemAppear(index)
                    }
                }
            }
            .background(.white)
        }
    }
}

#Preview {
    ListImagesView(
        items: [.mock, .mock, .mock, .mock],
        onItemAppear: { _ in },
        didSelect: { _ in }
    )
}
