import Foundation

public extension Listing {
    struct PageSummary: Sendable {
        let hasNextPage: Bool
        let firstItemIndex: Int
        let size: Int
        let pageId: String?

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
