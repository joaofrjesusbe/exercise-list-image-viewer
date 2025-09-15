import Foundation
import AppCore
import AppGroup

public enum ImagesListIntent: Equatable {
    case initialSearch
    case updateSearchText(String)
    case submitSearch
    case newItemAppeared(Int)
    case reloadNextPage
}

public struct ImagesListState: Equatable {
    let query: String
    let listingItems: [DSListCell.Item]
    let listingState: ListingLoadState
}

extension ImagesListState {
    
    func withNewQuery(_ query: String) -> Self {
        .init(query: query, listingItems: [], listingState: .idle)
    }
    
    func withUpdatedListing(_ listingItems: [DSListCell.Item]) -> Self {
        .init(query: query, listingItems: listingItems, listingState: .current)
    }
    
    func withLoadingPage() -> Self {
        .init(query: query, listingItems: listingItems, listingState: .loading)
    }
    
    func withErrorPage(_ errorState: ErrorState) -> Self {
        .init(query: query, listingItems: listingItems, listingState: .failed(errorState))
    }
}
