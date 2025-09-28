import Testing
@testable import AppImagesList
import AppGroup
import SwiftUI

@MainActor
struct ImagesListViewModelTests {

    // MARK: - Mocks
    @MainActor
    final class MockProvider: ImageListProvidable {
        var query: String
        var currentListing: ImageInfoListing = .init()

        var loadNextPageHandler: (() throws -> Void)?
        var shouldLoadNextPageHandler: ((Int) -> Bool)?

        private(set) var resetCalls = 0
        private(set) var loadNextPageCalls = 0
        private(set) var lastResetQuery: String?

        init(query: String) {
            self.query = query
        }

        func reset(newQuery: String?) {
            resetCalls += 1
            if let q = newQuery { query = q }
            lastResetQuery = newQuery
            currentListing = .init()
        }

        func loadNextPage() async throws {
            loadNextPageCalls += 1
            if let handler = loadNextPageHandler {
                try handler()
            }
        }

        func shouldLoadNextPage(index: Int) -> Bool {
            shouldLoadNextPageHandler?(index) ?? false
        }
    }

    // MARK: - Helpers
    private func registerSimpleAdapter() {
        _ = Container.shared.imageInfoUIAdapter.register { @MainActor in
            struct SimpleAdapter: ImageInfoUIAdaptable {
                func toCellItem(_ imageInfo: ImageInfo) -> DSListCellItem {
                    DSListCellItem(
                        id: String(imageInfo.id),
                        title: "T",
                        description: "D",
                        icon: nil
                    )
                }
                func toUserString(_ imageInfo: ImageInfo) -> LocalizedStringResource { "T" }
                func toLikesString(_ imageInfo: ImageInfo) -> LocalizedStringResource { "D" }
            }
            return SimpleAdapter()
        }
    }

    private func makeItems(_ count: Int) -> [ImageInfo] {
        (0..<count).map { idx in
            ImageInfo(id: UInt64(idx), previewURL: "p", largeImageURL: "l", user: "u", likes: 1)
        }
    }

    // MARK: - Tests

    @Test
    func initialSearch_setsLoading_thenCurrentStateWithItems() async throws {
        registerSimpleAdapter()

        let provider = MockProvider(query: "Start")
        provider.loadNextPageHandler = { [weak provider] in
            guard let provider else { return }
            provider.currentListing = provider.currentListing.appendPage(arrayItems: self.makeItems(3))
        }

        let sut = ImagesListViewModel(provider: provider)

        sut.send(.initialSearch)
        try await Task.sleep(nanoseconds: 80_000_000)

        #expect(provider.resetCalls == 1)

        guard case let .current(viewState) = sut.state else {
            Issue.record("Expected current state after initialSearch")
            return
        }

        #expect(viewState.query == "Start")
        #expect(viewState.listingItems.count == 3)
        #expect({ if case .idle = viewState.listingState { true } else { false } }())
        #expect(sut.query == "Start")
    }

    @Test
    func submitSearch_usesUserText_andResetsProvider() async throws {
        registerSimpleAdapter()

        let provider = MockProvider(query: "Original")
        provider.loadNextPageHandler = { [weak provider] in
            guard let provider else { return }
            provider.currentListing = provider.currentListing.appendPage(arrayItems: self.makeItems(2))
        }

        let sut = ImagesListViewModel(provider: provider)
        sut.send(.updateSearchText("Cats"))
        sut.send(.submitSearch)

        try await Task.sleep(nanoseconds: 80_000_000)

        #expect(provider.resetCalls == 1)
        #expect(provider.lastResetQuery == "Cats")

        guard case let .current(viewState) = sut.state else {
            Issue.record("Expected current state after submitSearch")
            return
        }
        #expect(viewState.query == "Cats")
        #expect(sut.query == "Cats")
        #expect(viewState.listingItems.count == 2)
    }

    @Test
    func reloadNextPage_appendsItems_andSetsListingState() async throws {
        registerSimpleAdapter()

        let provider = MockProvider(query: "Q")
        // First page on initial load
        provider.loadNextPageHandler = { [weak provider] in
            guard let provider else { return }
            if provider.currentListing.items.isEmpty {
                provider.currentListing = provider.currentListing.appendPage(arrayItems: self.makeItems(2))
            } else {
                provider.currentListing = provider.currentListing.appendPage(arrayItems: self.makeItems(2))
            }
        }

        let sut = ImagesListViewModel(provider: provider)
        sut.send(.initialSearch)
        try await Task.sleep(nanoseconds: 80_000_000)

        // Trigger next page
        sut.send(.loadNextPage)
        try await Task.sleep(nanoseconds: 80_000_000)

        guard case let .current(viewState) = sut.state else {
            Issue.record("Expected current state after reloadNextPage")
            return
        }
        #expect(viewState.listingItems.count == 4)
        #expect({ if case .current = viewState.listingState { true } else { false } }())
        #expect(provider.loadNextPageCalls == 2)
    }

    @Test
    func newItemAppeared_triggersLoadOnlyWhenThresholdMet() async throws {
        registerSimpleAdapter()

        let provider = MockProvider(query: "Q")
        provider.shouldLoadNextPageHandler = { index in index >= 5 }
        provider.loadNextPageHandler = { [weak provider] in
            guard let provider else { return }
            provider.currentListing = provider.currentListing.appendPage(arrayItems: self.makeItems(1))
        }

        let sut = ImagesListViewModel(provider: provider)
        sut.send(.initialSearch)
        try await Task.sleep(nanoseconds: 80_000_000)
        #expect(provider.loadNextPageCalls == 1)

        sut.send(.newItemAppeared(3)) // should NOT load
        sut.send(.newItemAppeared(5)) // should load
        try await Task.sleep(nanoseconds: 80_000_000)

        #expect(provider.loadNextPageCalls == 2)
    }

    @Test
    func initialSearch_failure_setsFailedState() async throws {
        let provider = MockProvider(query: "Q")
        provider.loadNextPageHandler = {
            throw NetworkError.general
        }

        let sut = ImagesListViewModel(provider: provider)
        sut.send(.initialSearch)
        try await Task.sleep(nanoseconds: 80_000_000)

        #expect(sut.state.failedState != nil)
    }

    @Test
    func reloadNextPage_failure_setsListingFailedState() async throws {
        registerSimpleAdapter()

        let provider = MockProvider(query: "Q")
        provider.loadNextPageHandler = { [weak provider] in
            guard let provider else { return }
            // First call succeeds, second fails
            if provider.currentListing.items.isEmpty {
                provider.currentListing = provider.currentListing.appendPage(arrayItems: self.makeItems(1))
            } else {
                throw NetworkError.general
            }
        }

        let sut = ImagesListViewModel(provider: provider)
        sut.send(.initialSearch)
        try await Task.sleep(nanoseconds: 80_000_000)

        sut.send(.loadNextPage)
        try await Task.sleep(nanoseconds: 80_000_000)

        guard case let .current(viewState) = sut.state else {
            Issue.record("Expected current state after reloadNextPage failure")
            return
        }
        #expect({ if case .failed = viewState.listingState { true } else { false } }())
    }
}

