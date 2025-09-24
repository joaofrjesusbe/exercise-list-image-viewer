import Foundation

public extension Listing {
    struct PageSummary: Sendable, Equatable, Hashable {
        fileprivate(set) var hasNextPage: Bool
        let firstItemIndex: Int
        let size: Int
        let pageId: String?

        var isEmpty: Bool { size == 0 }

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

extension Listing.PageSummary {
    
    func withNextPage() -> Self {
        var summary = self
        summary.hasNextPage = true
        return summary
    }    
}
