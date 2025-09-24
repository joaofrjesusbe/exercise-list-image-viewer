import Foundation

public extension Listing {
    struct Page {
        public let items: [Item]
        public let pageNumber: Int
        public let hasNextPage: Bool
        public let totalNumberOfItems: Int?
        public let totalNumberOfPages: Int?
        public let metadata: Metadata?
        public let id: String?
        
        public init(
            items: [Item],
            pageNumber: Int,
            hasNextPage: Bool,
            totalNumberOfItems: Int? = nil,
            totalNumberOfPages: Int? = nil,
            metadata: Metadata? = nil,
            id: String? = nil
        ) {
            self.items = items
            self.pageNumber = pageNumber
            self.hasNextPage = hasNextPage
            self.totalNumberOfItems = totalNumberOfItems
            self.totalNumberOfPages = totalNumberOfPages
            self.metadata = metadata
            self.id = id
        }
    }
}

extension Listing.Page: Sendable where Metadata: Sendable, Item: Sendable {}
