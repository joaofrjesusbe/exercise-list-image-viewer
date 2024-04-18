import Foundation

class ListingMemoryRepository<Service: ListingService>: ListingRepository {
    enum RepositoryError: Error {
        case deallocated
    }

    let service: Service
    private let minimumOffsetToLoadNextPage: Int
    private var pendingRequest: Task<Service.AssociatedListingPage, Error>?

    private(set) var query: Service.Query
    private(set) var currentListing: AssociatedListing

    init(
        query: Service.Query,
        provider: Service,
        minimumOffsetToLoadNextPage: Int
    ) {
        self.query = query
        self.service = provider
        self.minimumOffsetToLoadNextPage = minimumOffsetToLoadNextPage
        self.currentListing = AssociatedListing()
    }

    func reset(newQuery: Service.Query?) async {
        pendingRequest?.cancel()
        pendingRequest = nil
        if let newQuery = newQuery {
            self.query = newQuery
        }
        currentListing = AssociatedListing()
    }

    func loadNextPage() async throws -> AssociatedListing {
        defer {
            pendingRequest = nil
        }

        let nextPage = currentListing.nextPage
        pendingRequest = getTask(nextPage: nextPage)

        guard let pageInfo = try await pendingRequest?.value else {
            throw RepositoryError.deallocated
        }

        currentListing = currentListing.appendPage(page: pageInfo)
        return currentListing
    }

    func shouldLoadNextPage(index: Int) -> Bool {
        guard index >= currentListing.items.count - minimumOffsetToLoadNextPage else {
            return false
        }

        guard pendingRequest == nil, currentListing.hasNextPage else {
            return false
        }

        return true
    }

    func getTask(nextPage: Int) -> Task<Service.AssociatedListingPage, Error> {
        Task { [weak self] in
            guard let self else {
                throw RepositoryError.deallocated
            }

            return try await service.requestPage(query: query, page: nextPage)
        }
    }
}
