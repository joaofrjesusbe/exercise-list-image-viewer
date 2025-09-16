import SwiftUI
import AppGroup

@MainActor
public protocol ImageListProvidable {
    var query: String { get }
    var currentListing: ImageInfoListing { get }
    
    func reset(newQuery: String?)
    func loadNextPage() async throws
    func shouldLoadNextPage(index: Int) -> Bool
}

public final class ImageListProvider: ImageListProvidable {
    public private(set) var query: String
    public private(set) var currentListing = ImageInfoListing()
    
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
    
    public func reset(newQuery: String?) {
        pendingRequest?.cancel()
        pendingRequest = nil
        if let newQuery = newQuery {
            self.query = newQuery
            logger.info("New query: \(query)")
        }
        
        currentListing = ImageInfoListing()
    }
    
    public func loadNextPage() async throws {
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

    public func shouldLoadNextPage(index: Int) -> Bool {
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
