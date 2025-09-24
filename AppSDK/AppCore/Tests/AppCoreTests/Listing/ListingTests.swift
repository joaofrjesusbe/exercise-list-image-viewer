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
        #expect(listing.lastPageId == nil)
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
        #expect(listing.lastPageId == "p1")
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
        #expect(listing.lastPageId == "p2")
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
        // Build listing and append first page (absolute indexing)
        var listing = Listing<Int, String>()
        let page = makePage([1, 2, 3], page: 1, hasNext: false, id: "pg")
        listing = listing.appendPage(page)
        let summary = listing.pages[0]

        // Absolute indices: first page starts at 0
        #expect(summary.size == 3)
        #expect(summary.firstItemIndex == 0)
        #expect(summary.lastItemIndex == 2)
        #expect(summary.range == 0..<3)
        #expect(summary.contains(index: 0))
        #expect(summary.contains(index: 2))
        #expect(!summary.contains(index: 3))

        // withNextPage flips the flag to true
        let next = summary.withNextPage()
        #expect(next.hasNextPage == true)
    }

    // MARK: - pageItems
    @Test
    func pageItems_returns_correct_slice_per_page() {
        var listing = Listing<Int, String>()

        // Append three pages with sizes 3, 2, 0 respectively
        listing = listing.appendPage(makePage([1, 2, 3], page: 1, hasNext: true, id: "p1"))
        listing = listing.appendPage(makePage([4, 5], page: 2, hasNext: true, id: "p2"))
        listing = listing.appendPage(makePage([], page: 3, hasNext: false, id: "p3"))

        // Absolute items array is [1,2,3,4,5]
        #expect(listing.items == [1, 2, 3, 4, 5])

        // Validate slices by page number (1-based)
        #expect(listing.pageItems(page: 1) == [1, 2, 3])
        #expect(listing.pageItems(page: 2) == [4, 5])
        #expect(listing.pageItems(page: 3).isEmpty)
    }

    @Test
    func pageItems_outOfBounds_or_emptyListing_returns_empty() {
        let empty = Listing<Int, String>()
        #expect(empty.pageItems(page: 1).isEmpty)
        #expect(empty.pageItems(page: 0).isEmpty)
        #expect(empty.pageItems(page: -1).isEmpty)

        var listing = Listing<Int, String>()
        listing = listing.appendPage(makePage([10], page: 1, hasNext: false))
        #expect(listing.pageItems(page: 0).isEmpty)
        #expect(listing.pageItems(page: -2).isEmpty)
        #expect(listing.pageItems(page: 2).isEmpty)
    }

    // MARK: - Totals semantics (non-nil only)
    @Test
    func totals_update_only_when_non_nil() {
        var listing = Listing<Int, String>()
        let p1 = makePage([1, 2], page: 1, hasNext: true, totalItems: 10, totalPages: 5, metadata: nil, id: "p1")
        let p2 = makePage([3], page: 2, hasNext: false, totalItems: nil, totalPages: nil, metadata: nil, id: "p2")

        listing = listing.appendPage(p1)
        #expect(listing.totalNumberOfItems == 10)
        #expect(listing.totalNumberOfPages == 5)

        listing = listing.appendPage(p2)
        // Totals should remain from p1 because p2 provided nil values
        #expect(listing.totalNumberOfItems == 10)
        #expect(listing.totalNumberOfPages == 5)
        #expect(listing.items == [1, 2, 3])
    }

    // MARK: - pageSlice behavior
    @Test
    func pageSlice_returns_correct_slice_and_empty_when_out_of_bounds() {
        var listing = Listing<Int, String>()
        listing = listing.appendPage(makePage([1, 2, 3], page: 1, hasNext: true, id: "p1"))
        listing = listing.appendPage(makePage([4, 5], page: 2, hasNext: true, id: "p2"))
        listing = listing.appendPage(makePage([], page: 3, hasNext: false, id: "p3"))

        let s1 = listing.pageSlice(page: 1)
        let s2 = listing.pageSlice(page: 2)
        let s3 = listing.pageSlice(page: 3)
        let sOutLow  = listing.pageSlice(page: 0)
        let sOutHigh = listing.pageSlice(page: 4)

        #expect(Array(s1) == [1, 2, 3])
        #expect(Array(s2) == [4, 5])
        #expect(s3.isEmpty)
        #expect(sOutLow.isEmpty)
        #expect(sOutHigh.isEmpty)
    }

    // MARK: - removeAll behavior
    @Test
    func removeAll_keepingMetadata_true_preserves_metadata_and_resets_state() {
        var listing = Listing<Int, String>()
        listing = listing.appendMetadata(metadata: "M")
        listing = listing.appendPage(makePage([1, 2], page: 1, hasNext: false, totalItems: 2, totalPages: 1, id: "p1"))

        #expect(!listing.items.isEmpty)
        #expect(!listing.pages.isEmpty)
        #expect(listing.totalNumberOfItems == 2)
        #expect(listing.totalNumberOfPages == 1)
        #expect(listing.metadata == "M")

        listing.removeAll(keepingMetadata: true)

        #expect(listing.items.isEmpty)
        #expect(listing.pages.isEmpty)
        #expect(listing.totalNumberOfItems == nil)
        #expect(listing.totalNumberOfPages == nil)
        #expect(listing.metadata == "M")
    }

    @Test
    func removeAll_keepingMetadata_false_clears_metadata_and_resets_state() {
        var listing = Listing<Int, String>()
        listing = listing.appendMetadata(metadata: "M")
        listing = listing.appendPage(makePage([10], page: 1, hasNext: false, totalItems: 1, totalPages: 1, id: "p1"))

        listing.removeAll(keepingMetadata: false)

        #expect(listing.items.isEmpty)
        #expect(listing.pages.isEmpty)
        #expect(listing.totalNumberOfItems == nil)
        #expect(listing.totalNumberOfPages == nil)
        #expect(listing.metadata == nil)
    }

    // MARK: - Ordering invariants
    @Test
    func canAppend_returns_true_only_for_expected_next_page() {
        var listing = Listing<Int, String>()
        // Before any pages, nextPage is 1
        let p1 = makePage([1], page: 1, hasNext: true)
        let p2 = makePage([2], page: 2, hasNext: false)
        let p3 = makePage([3], page: 3, hasNext: false)

        #expect(listing.canAppend(p1))
        #expect(!listing.canAppend(p2))

        listing = listing.appendPage(p1)
        #expect(listing.nextPage == 2)
        #expect(listing.canAppend(p2))
        #expect(!listing.canAppend(p3))

        listing = listing.appendPage(p2)
        #expect(listing.nextPage == 3)
        #expect(listing.canAppend(p3))
    }

    @Test
    func appending_out_of_order_page_triggers_precondition_in_debug() {
        // This test documents the invariant; it does not actually trigger a crash here.
        // We assert the guard method instead of causing a precondition failure in tests.
        let listing = Listing<Int, String>()
        let p2 = makePage([2], page: 2, hasNext: false)
        #expect(!listing.canAppend(p2))
    }
}
