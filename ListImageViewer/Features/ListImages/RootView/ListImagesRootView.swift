import SwiftUI

struct ListImagesRootView: View {
    let viewModel: ListImagesViewModel
    let router: ListImagesRouter
    
    var body: some View {
        ZStack(alignment: .center) {
            stateView
        }
        .background(.white)        
        .navigationTitle("List")
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
                didSelect: router.openDetailImage
            )
        case .failed:
            Text("Ups something went wrong")
        }
    }
}
