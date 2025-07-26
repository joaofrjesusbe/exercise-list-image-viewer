import Foundation

public struct Listing<Item, Metadata> {
    public private(set) var totalNumberOfItems: Int?
    public private(set) var totalNumberOfPages: Int?
    public private(set) var metadata: Metadata?
    public private(set) var items: [Item] = []
    public private(set) var pages: [PageSummary] = []
    
    public init() {}
}

extension Listing: Sendable where Item: Sendable, Metadata: Sendable {}

public extension Listing {
    
    var isEmpty: Bool {
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
    
    var lastID: String? {
        pages.last?.pageId
    }

    func appendPage(_ page: Listing.Page) -> Listing {
        var listing = self
        
        if let lastPage = listing.pages.last {
            listing.pages[listing.pages.count - 1] = lastPage.withNextPage()
        }

        // note: only replace metadata if there is any
        if let metadata = page.metadata {
            listing.metadata = metadata
        }
        
        listing.totalNumberOfItems = page.totalNumberOfItems
        listing.totalNumberOfPages = page.totalNumberOfPages
        listing.pages.append(page.summarized())
        listing.items.append(contentsOf: page.items)
        return listing
    }
    
    func appendPage(arrayItems: [Item]) -> Listing {
        let pageNumber = nextPage
        let page = Listing.Page(
            items: arrayItems,
            pageNumber: pageNumber,
            hasNextPage: false
        )
        return appendPage(page)
    }
    
    func appendMetadata(metadata: Metadata) -> Listing {
        var listing = self
        listing.metadata = metadata
        return listing
    }
}
