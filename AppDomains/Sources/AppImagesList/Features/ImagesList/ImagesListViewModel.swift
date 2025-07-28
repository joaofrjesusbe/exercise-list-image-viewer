import SwiftUI
import AppCore
import PixbayNetwork
import FactoryKit

@MainActor
public class ImagesListViewModel: LoadViewModel<ImagesListState, ImagesListIntent> {
    @Injected(\.imageInfoUIAdapter) private var adapter
    private let provider: ImageListProvider
    
    public init(provider: ImageListProvider) {
        self.provider = provider
        super.init()
    }
    
    public override func send(_ intent: ImagesListIntent) {
        switch intent {
        case .initialSearch:
            initialLoad()
        case .newItemAppeared(let index):
            tryToLoadNextPage(index: index)
        case .reloadNextPage:
            loadNextPage()
        case .selectItem(let index):
            provider.selectIndex(index)
        }
    }
    
    public override func onChangeLanguageManager() {
        guard let viewState = state.viewState else { return }
        let items = adapter.toArrayCellItems(provider.currentListing.items)
        updateViewState(viewState.withUpdatedListing(items))
    }
    
    private func initialLoad() {
        updateLoading()
        
        Task { @MainActor in
            do {
                try await provider.initialLoad()
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
