import Foundation
import AppCore
import DesignSystem

public enum ImagesListIntent {
    case initialSearch
    case newItemAppeared(Int)
    case reloadNextPage
    case selectItem(Int)
}

public struct ImagesListState {
    let query: String
    let listingItems: [DSListCell.Item]
    let listingState: ListingLoadState
}

extension ImagesListState {
    
    func withNewQuery(_ query: String) -> Self {
        .init(query: query, listingItems: [], listingState: .idle)
    }
    
    func withUpdatedListing(_ listingItems: [DSListCell.Item]) -> Self {
        .init(query: query, listingItems: listingItems, listingState: .didLoadEmpty)
    }
    
    func withLoadingPage() -> Self {
        .init(query: query, listingItems: listingItems, listingState: .loading)
    }
    
    func withErrorPage(_ errorState: ErrorState) -> Self {
        .init(query: query, listingItems: listingItems, listingState: .failed(errorState))
    }
}
