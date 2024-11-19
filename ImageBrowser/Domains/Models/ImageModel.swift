import SwiftUI
import ImageCore
import ImageIO

@MainActor
final class ImageModel: ObservableObject {
    @Published private(set) var query: String
    @Published private(set) var currentListing = ImageInfoListing()
    
    private let provider: ImageService
    private let minimumOffsetToLoadNextPage: Int    
    private var pendingRequest: Task<ImageInfoListing.Page, Error>?
    
    init(
        query: String,
        provider: ImageService,
        minimumOffsetToLoadNextPage: Int
    ) {
        self.provider = provider
        self.query = query
        self.minimumOffsetToLoadNextPage = minimumOffsetToLoadNextPage
    }
    
    func reset(newQuery: String?) {
        pendingRequest?.cancel()
        pendingRequest = nil
        if let newQuery = newQuery {
            self.query = newQuery
        }
        
        currentListing = ImageInfoListing()
    }
    
    func initialLoad() async throws {
        reset(newQuery: nil)
        try await loadNextPage()
    }
    
    func loadNextPage() async throws {
        defer {
            pendingRequest = nil
        }

        guard pendingRequest == nil else {
            return
        }
        
        let nextPage = currentListing.nextPage
        pendingRequest = getTask(nextPage: nextPage)

        guard let pageInfo = try await pendingRequest?.value else {
            throw NetworkError.general
        }

        currentListing = currentListing.appendPage(pageInfo)
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
        
    private func getTask(nextPage: Int) -> Task<ImageInfoListing.Page, Error> {
        Task { [weak self] in
            guard let self else {
                throw NetworkError.deallocated
            }

            return try await provider.requestPage(query: query, pageNumber: nextPage)
        }
    }
}
