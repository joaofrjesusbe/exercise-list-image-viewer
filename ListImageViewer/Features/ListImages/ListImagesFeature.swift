import SwiftUI

final class ListImagesFeature: UIHostingController<ListImagesRootView> {
    private let viewModel: ListImagesViewModel
    private let router: ListImagesRouter

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor init(_ router: ListImagesRouter) {
        let service = ListImagesNetworkService()
        self.viewModel = Self.createViewModel(service: service)
        self.router = router

        let rootView = ListImagesRootView(viewModel: viewModel, router: router)
        super.init(rootView: rootView)

        Task {
            await viewModel.loadImages()
        }
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
