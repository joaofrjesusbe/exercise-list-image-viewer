struct Listing<Item, Metadata> {
    private(set) var totalNumberOfItems: Int?
    private(set) var totalNumberOfPages: Int?
    private(set) var metadata: Metadata?
    private(set) var items: [Item] = []
    private(set) var pages: [PageInfo] = []

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

    func appendPage(page: ListingPage<Item, Metadata>) -> Listing {
        var listing = self
        let pageInfo = PageInfo(
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

extension Listing {
    struct PageInfo {
        let hasNextPage: Bool
        let firstItemIndex: Int
        let size: Int

        var lastItemIndex: Int {
            firstItemIndex + size - 1
        }

        var range: Range<Int> {
            firstItemIndex ..< firstItemIndex + size
        }

        func contains(index: Int) -> Bool {
            range.contains(index)
        }
    }
}
