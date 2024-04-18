import SwiftUI

protocol ListingService {
    associatedtype Item
    associatedtype Query
    associatedtype Metadata

    typealias AssociatedListingPage = ListingPage<Item, Metadata>

    func requestPage(
        query: Query,
        page: Int
    ) async throws -> AssociatedListingPage
}

protocol ListingRepository {
    associatedtype Service: ListingService

    typealias AssociatedListing = Listing<Service.Item, Service.Metadata>

    var currentListing: AssociatedListing { get }

    func reset(newQuery: Service.Query?) async

    func loadNextPage() async throws -> AssociatedListing

    func shouldLoadNextPage(index: Int) -> Bool
}

extension ListingRepository {

    func reset() async {
        await reset(newQuery: nil)
    }
}
