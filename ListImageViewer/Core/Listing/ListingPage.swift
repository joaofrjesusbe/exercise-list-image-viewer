import Foundation

struct ListingPage<Item, Metadata> {
    var totalNumberOfItems: Int?
    var totalNumberOfPages: Int?
    var hasNextPage: Bool = false
    let metadata: Metadata?
    let items: [Item]
    let pageNumber: Int

    init(pageNumber: Int, items: [Item], metadata: Metadata? = nil) {
        self.pageNumber = pageNumber
        self.items = items
        self.metadata = metadata
    }
}
