import SwiftUI

class ListImagesFeature {
    let viewModel: ListImagesViewModel
    let router: ListImagesRouter

    init(router: ListImagesRouter) {
        self.router = router
        self.viewModel = Self.createViewModel(service: ListImagesNetworkService())

        Task {
            await viewModel.loadImages()
        }
    }

    var mainView: some View {
        ListImagesRootView(viewModel: viewModel, router: router)
    }

    static func createViewModel<Service: ListImagesService>(
        service: Service
    ) -> ListImagesViewModel {
        let query = "yellow+flowers"
        let repository = ListImagesMemoryRepository(
            query: query,
            provider: service,
            minimumOffsetToLoadNextPage: 5
        )
        let action = NextImagesPageAction(repository: repository)
        return ListImagesViewModel(action: action)
    }
}
