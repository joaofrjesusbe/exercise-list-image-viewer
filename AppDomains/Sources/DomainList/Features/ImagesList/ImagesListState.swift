import Foundation
import AppCore
import PixbayNetwork

public enum ImagesListIntent {
    case initialSearch
    case newItemAppeared(Int)
    case loadNextPage
    case selectItem(Int)
}

public struct ImagesListState {
    let query: String
    let listing: ImageInfoListing
    let listingState: ListingState
}

extension ImagesListState {
    
    func withNewQuery(_ query: String) -> Self {
        .init(query: query, listing: Listing(), listingState: .idle)
    }
    
    func withUpdatedListing(_ listing: ImageInfoListing) -> Self {
        .init(query: query, listing: listing, listingState: .didLoadVoid)
    }
    
    func withLoadingPage() -> Self {
        .init(query: query, listing: listing, listingState: .loading)
    }
    
    func withErrorPage(_ errorState: ErrorState) -> Self {
        .init(query: query, listing: listing, listingState: .failed(errorState))
    }
}

extension ImagesListState {
    @MainActor
    static let mock = {
        let listing = ImageInfoListing()
            .appendPage(arrayItems: [.mock, .mock, .mock])
            .appendPage(arrayItems: [.mock, .mock, .mock])
            .appendPage(arrayItems: [.mock, .mock, .mock])
        
        return ImagesListState(
            query: "Flowers",
            listing: listing,
            listingState: .loading
        )
    }()
}
