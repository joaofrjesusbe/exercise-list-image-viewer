import Foundation

public struct Listing<Item: Sendable, Metadata: Sendable>: Sendable {
    public private(set) var totalNumberOfItems: Int?
    public private(set) var totalNumberOfPages: Int?
    public private(set) var metadata: Metadata?
    public private(set) var items: [Item] = []
    public private(set) var pages: [PageSummary] = []
    
    public init() {}
}

public extension Listing {
    
    var hasResults: Bool {
        !pages.isEmpty
    }

    var hasNextPage: Bool {
        guard let pageInfo = pages.last else {
            return true
        }
        return pageInfo.hasNextPage
    }

    var nextPage: Int {
        pages.count + 1
    }

    func appendPage(_ page: Listing.Page) -> Listing {
        var listing = self
        let pageInfo = PageSummary(
            hasNextPage: page.hasNextPage,
            firstItemIndex: listing.items.count,
            size: page.items.count
        )

        listing.totalNumberOfItems = page.totalNumberOfItems
        listing.totalNumberOfPages = page.totalNumberOfPages
        listing.metadata = page.metadata
        listing.pages.append(pageInfo)
        listing.items.append(contentsOf: page.items)
        return listing
    }
}

public extension Listing {
    struct Page: Sendable {
        public var totalNumberOfItems: Int?
        public var totalNumberOfPages: Int?
        public var hasNextPage: Bool = false
        public let metadata: Metadata?
        public let items: [Item]
        public let pageNumber: Int
        
        public init(pageNumber: Int, items: [Item], metadata: Metadata? = nil) {
            self.pageNumber = pageNumber
            self.items = items
            self.metadata = metadata
        }
    }
}
