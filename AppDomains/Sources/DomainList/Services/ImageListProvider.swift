import SwiftUI
import AppCore
import PixbayNetwork

@MainActor
public final class ImageListProvider {
    private(set) var query: String
    private(set) var currentListing = ImageInfoListing()
    private(set) var currentItem: ImageInfo?

    private let service: ImagePageService
    private let minimumOffsetToLoadNextPage: Int
    private var pendingRequest: Task<ImageInfoListing.Page, Error>?
    
    public init(
        query: String,
        service: ImagePageService,
        minimumOffsetToLoadNextPage: Int
    ) {
        self.service = service
        self.query = query
        self.minimumOffsetToLoadNextPage = minimumOffsetToLoadNextPage
    }
    
    func selectIndex(_ index: Int) {
        currentItem = currentListing.items[index]
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
        let service = service
        let query = query
        return Task {
            try await service.requestPage(query: query, pageNumber: nextPage)
        }
    }
}
