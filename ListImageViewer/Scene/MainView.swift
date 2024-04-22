import SwiftUI

struct MainView: View {
    var mainCoordinator:

    var body: some View {
        NavigationStack {
            
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
                didSelect: dependency.openImageDetailRoute
            )
        case .failed:
            Text("Ups something went wrong")
        }
    }
}
