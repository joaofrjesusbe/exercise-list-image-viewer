import SwiftUI
import AppGroup

@MainActor
public class ImagesListViewModel: LoadViewModel<ImagesListState, ImagesListIntent> {
    @Injected(\.imageInfoUIAdapter) private var adapter

    private let provider: ImageListProvider
    private var userSearchText: String?
    
    @Published public private(set) var query: String
    
    public init(provider: ImageListProvider) {
        self.provider = provider
        self.query = provider.query
        super.init()
    }
    
    public override func send(_ intent: ImagesListIntent) {
        switch intent {
        case .initialSearch:
            initialLoad(query: nil)
        case .newItemAppeared(let index):
            tryToLoadNextPage(index: index)
        case .reloadNextPage:
            loadNextPage()
        case .selectItem(let index):
            provider.selectIndex(index)
        case .updateSearchText(let value):
            userSearchText = value
        case .submitSearch:
            initialLoad(query: userSearchText)
        }
    }
    
    private func initialLoad(query: String?) {
        self.query = query ?? provider.query
        updateLoading()
        
        Task { @MainActor in
            do {
                try await provider.initialLoad(query: query)
                let items = adapter.toArrayCellItems(provider.currentListing.items)
                updateViewState(
                    ImagesListState(
                        query: provider.query,
                        listingItems: items,
                        listingState: .idle
                    )
                )
            } catch  {
                updateError(error)
            }
        }
    }
    
    private func loadNextPage() {
        guard let viewState = state.viewState else { return }
        Task { @MainActor in
            do {
                updateViewState(viewState.withLoadingPage())
                try await provider.loadNextPage()
                let items = adapter.toArrayCellItems(provider.currentListing.items)
                updateViewState(viewState.withUpdatedListing(items))
            } catch {
                updateViewState(viewState.withErrorPage(errorMapper.mapError(error)))
            }
        }
    }
    
    private func tryToLoadNextPage(index: Int) {
        if provider.shouldLoadNextPage(index: index) {
            loadNextPage()
        }
    }
}
