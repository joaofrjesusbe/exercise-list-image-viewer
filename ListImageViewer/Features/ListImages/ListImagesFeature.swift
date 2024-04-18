import SwiftUI

final class ListImagesFeature: UIHostingController<ListImagesRootView> {
    private let router: ListImagesRouter
    private let viewModel: ListImagesViewModel

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor init(router: ListImagesRouter) {
        self.router = router
        
        let service = ListImagesNetworkService()
        self.viewModel = Self.createViewModel(service: service)

        let rootView = ListImagesRootView(router: router, viewModel: viewModel)
        super.init(rootView: rootView)
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
