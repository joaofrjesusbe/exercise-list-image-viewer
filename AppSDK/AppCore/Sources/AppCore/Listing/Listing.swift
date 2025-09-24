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
extension Listing: Equatable where Item: Equatable, Metadata: Equatable {}
extension Listing: Hashable where Item: Hashable, Metadata: Hashable {}

public extension Listing {
    
    var isEmpty: Bool { items.isEmpty }
    
    /// The 1-based page number for the next page to request.
    /// Pages must be appended in order starting at 1.
    var nextPage: Int { pages.count + 1 }
    
    var lastPageItems: [Item] { pageItems(page: pages.count) }
    
    var lastPageId: String? { pages.last?.pageId }
    
    var pageCount: Int { pages.count }
    
    var totalLoadedItems: Int { items.count }
    
    var hasNextPage: Bool {
        guard let pageInfo = pages.last else {
            return true
        }
        return pageInfo.hasNextPage
    }
    
    /// Returns true if the given page can be appended according to the ordering invariant.
    /// Pages must be appended in ascending order starting at 1.
    func canAppend(_ page: Listing.Page) -> Bool {
        page.pageNumber == nextPage
    }
    
    func pageRange(page: Int) -> Range<Int>? {
        guard page > 0, page <= pages.count else { return nil }
        let range = pages[page - 1].range // absolute 0-based range into items
        let start = max(0, range.lowerBound)
        let end = min(items.count, range.upperBound)
        guard start < end else { return nil }
        return start..<end
    }
    
    /// Returns the items for the given 1-based page number.
    func pageItems(page: Int) -> [Item] {
        guard let range = pageRange(page: page) else { return [] }
        return Array(items[range])
    }
    
    /// Returns a non-copying slice for the given 1-based page number.
    /// If the page is out of bounds or empty, returns an empty slice.
    func pageSlice(page: Int) -> ArraySlice<Item> {
        guard let range = pageRange(page: page) else { return ArraySlice<Item>() }
        return items[range]
    }
    
    func appendPage(_ page: Listing.Page) -> Listing {
        var listing = self
        listing.addPage(page)
        return listing
    }
    
    func appendPage(arrayItems: [Item], hasNextPage: Bool = false) -> Listing {
        var listing = self
        listing.addPage(arrayItems: arrayItems, hasNextPage: hasNextPage)
        return listing
    }
    
    func appendMetadata(metadata: Metadata) -> Listing {
        var listing = self
        listing.addMetadata(metadata)
        return listing
    }
    
    /// Appends a page to the listing. Requires pages to be appended in ascending order starting at 1.
    /// - Precondition: `page.pageNumber == nextPage`
    mutating func addPage(_ page: Listing.Page) {
        precondition(page.pageNumber == nextPage, "Pages must be appended in order starting at 1.")
        
        if let lastPage = pages.last {
            pages[pages.count - 1] = lastPage.withNextPage()
        }
        
        if let metadata = page.metadata { self.metadata = metadata }
        if let total = page.totalNumberOfItems { totalNumberOfItems = total }
        if let total = page.totalNumberOfPages { totalNumberOfPages = total }
        
        let startIndex = items.count
        let summary = Listing.PageSummary(
            hasNextPage: page.hasNextPage,
            firstItemIndex: startIndex,
            size: page.items.count,
            pageId: page.id
        )
        pages.append(summary)
        items.append(contentsOf: page.items)
    }
    
    mutating func addPage(arrayItems: [Item], hasNextPage: Bool = false) {
        let pageNumber = nextPage
        let page = Listing.Page(
            items: arrayItems,
            pageNumber: pageNumber,
            hasNextPage: hasNextPage
        )
        addPage(page)
    }
    
    mutating func addMetadata(_ metadata: Metadata) {
        self.metadata = metadata
    }
    
    mutating func removeAll(keepingMetadata: Bool = true) {
        totalNumberOfItems = nil
        totalNumberOfPages = nil
        if !keepingMetadata { metadata = nil }
        items.removeAll(keepingCapacity: true)
        pages.removeAll(keepingCapacity: true)
    }
}


