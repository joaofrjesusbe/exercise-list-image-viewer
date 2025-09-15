@testable import AppCore
import Testing

// MARK: - Listing Tests (Swift Testing)

final class ListingTests: @unchecked Sendable {

    // MARK: - Helpers
    private func makePage(
        _ items: [Int],
        page: Int,
        hasNext: Bool,
        totalItems: Int? = nil,
        totalPages: Int? = nil,
        metadata: String? = nil,
        id: String? = nil
    ) -> Listing<Int, String>.Page {
        Listing<Int, String>.Page(
            items: items,
            pageNumber: page,
            hasNextPage: hasNext,
            totalNumberOfItems: totalItems,
            totalNumberOfPages: totalPages,
            metadata: metadata,
            id: id
        )
    }

    // MARK: - Basics
    @Test
    func default_init_is_empty_and_nextPage_is_1() {
        let listing = Listing<Int, String>()
        #expect(listing.isEmpty)
        #expect(listing.pages.isEmpty)
        #expect(listing.items.isEmpty)
        #expect(listing.nextPage == 1)
        #expect(listing.hasNextPage) // empty listing reports true by design
        #expect(listing.lastID == nil)
        #expect(listing.totalNumberOfItems == nil)
        #expect(listing.totalNumberOfPages == nil)
        #expect(listing.metadata == nil)
    }

    // MARK: - Appending pages
    @Test
    func append_first_page_updates_items_pages_totals_and_ids() {
        var listing = Listing<Int, String>()
        let page1 = makePage([1, 2], page: 1, hasNext: true, totalItems: 4, totalPages: 2, metadata: "M1", id: "p1")
        listing = listing.appendPage(page1)

        #expect(!listing.isEmpty)
        #expect(listing.items == [1, 2])
        #expect(listing.pages.count == 1)
        #expect(listing.pages.last?.hasNextPage == true)
        #expect(listing.totalNumberOfItems == 4)
        #expect(listing.totalNumberOfPages == 2)
        #expect(listing.metadata == "M1")
        #expect(listing.lastID == "p1")
        #expect(listing.nextPage == 2)
        #expect(listing.hasNextPage == true)
    }

    @Test
    func append_second_page_marks_previous_hasNext_true_and_last_uses_page_flag() {
        var listing = Listing<Int, String>()
        let page1 = makePage([1, 2], page: 1, hasNext: true, totalItems: 4, totalPages: 2, metadata: "M1", id: "p1")
        let page2 = makePage([3, 4], page: 2, hasNext: false, totalItems: 4, totalPages: 2, metadata: "M2", id: "p2")
        listing = listing.appendPage(page1)
        listing = listing.appendPage(page2)

        #expect(listing.items == [1, 2, 3, 4])
        #expect(listing.pages.count == 2)
        // First page summary is flipped to hasNextPage = true by append logic
        #expect(listing.pages[0].hasNextPage == true)
        // Last page summary uses the page flag (false here)
        #expect(listing.pages[1].hasNextPage == false)
        #expect(listing.hasNextPage == false)
        #expect(listing.lastID == "p2")
        #expect(listing.nextPage == 3)
        // Totals and metadata adopt the last page's non-nil values
        #expect(listing.totalNumberOfItems == 4)
        #expect(listing.totalNumberOfPages == 2)
        #expect(listing.metadata == "M2")
    }

    @Test
    func appendPage_arrayItems_convenience_sets_hasNext_false() {
        var listing = Listing<Int, String>()
        listing = listing.appendPage(arrayItems: [10, 20])
        #expect(listing.items == [10, 20])
        #expect(listing.pages.count == 1)
        #expect(listing.pages[0].hasNextPage == false)
        #expect(listing.hasNextPage == false)
    }

    // MARK: - Metadata behavior
    @Test
    func metadata_only_replaces_when_page_metadata_is_non_nil() {
        var listing = Listing<Int, String>()
        // Seed initial metadata via helper
        listing = listing.appendMetadata(metadata: "Seed")
        #expect(listing.metadata == "Seed")

        // Append a page with nil metadata -> should keep previous
        let p1 = makePage([1], page: 1, hasNext: true, metadata: nil)
        listing = listing.appendPage(p1)
        #expect(listing.metadata == "Seed")

        // Append a page with non-nil metadata -> should replace
        let p2 = makePage([2], page: 2, hasNext: false, metadata: "M2")
        listing = listing.appendPage(p2)
        #expect(listing.metadata == "M2")
    }

    // MARK: - PageSummary helpers
    @Test
    func page_summary_properties_and_withNextPage() {
        // Given a page of size 3
        let page = makePage([1, 2, 3], page: 1, hasNext: false, id: "pg")
        let summary = page.summarized()

        // The current implementation derives indices from page size
        #expect(summary.size == 3)
        #expect(summary.firstItemIndex == 3)
        #expect(summary.lastItemIndex == 5)
        #expect(summary.range == 3..<6)
        #expect(summary.contains(index: 3))
        #expect(summary.contains(index: 5))
        #expect(!summary.contains(index: 6))

        // withNextPage flips the flag to true
        let next = summary.withNextPage()
        #expect(next.hasNextPage == true)
    }
}

