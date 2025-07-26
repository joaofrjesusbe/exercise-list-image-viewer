import SwiftUI
import AppCore
import PixbayNetwork

@MainActor
public class ImagesListViewModel: AbstractViewModel<ImagesListState, ImagesListIntent> {
    private let provider: ImageListProvider
    
    public init(provider: ImageListProvider) {
        self.provider = provider
        super.init(errorMapper: MockErrorMapper())
    }
    
    public override func send(_ intent: ImagesListIntent) {
        switch intent {
        case .initialSearch:
            initialLoad()
        case .newItemAppeared(let index):
            tryToLoadNextPage(index: index)
        case .loadNextPage:
            loadNextPage()
        case .selectItem(let index):
            provider.selectIndex(index)
        }
    }
    
    private func initialLoad() {
        updateLoading()
        
        Task { @MainActor in
            do {
                try await provider.initialLoad()
                updateViewState(
                    ImagesListState(
                        query: provider.query,
                        listing: provider.currentListing,
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
                updateViewState(viewState.withUpdatedListing(provider.currentListing))
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
