import SwiftUI

struct ListImagesRootView: View {
    let router : ListImagesRouter
    var viewModel: ListImagesViewModel

    var body: some View {
        ZStack(alignment: .center) {
            stateView
        }
        .background(.white)
        .task {
            await viewModel.loadImages()
        }
    }

    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .images(let listImages):
            ListImagesView(
                items: listImages,
                onItemAppear: viewModel.itemDidAppear,
                didSelect: router.openImageDetailRoute
            )
        case .failed:
            Text("Ups something went wrong")
        }
    }
}
