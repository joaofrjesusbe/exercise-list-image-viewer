import SwiftUI
import FactoryKit
import AppCore
import PixbayNetwork

@MainActor
public final class ImageListProvider {
    private(set) var query: String
    private(set) var currentListing = ImageInfoListing()
    private(set) var currentItem: ImageInfo?

    @Injected(\.imagePageService) private var service
    @Injected(\.logger) private var logger
    
    private let minimumOffsetToLoadNextPage: Int
    private var pendingRequest: Task<ImageInfoListing.Page, Error>?
    
    public init(
        query: String,
        minimumOffsetToLoadNextPage: Int
    ) {
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
        logger.info("New query: \(query)")
    }
    
    func initialLoad(query: String? = nil) async throws {
        reset(newQuery: query)
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

extension ImageListProvider {
    static var mock: ImageListProvider {
        let _ = Container.shared.imagePageService.register { MockImagePageService() }
        let provider = ImageListProvider(query: "Funny", minimumOffsetToLoadNextPage: 5)
        return provider
    }
}
