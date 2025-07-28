import PixbayNetwork
import DesignSystem

extension ImagesListState {
    @MainActor
    static var mock: Self {
        var itemMocks: [DSListCell.Item] = []
        let adapter = ImageInfoUIAdapter()
        for _ in 0..<20 {
            itemMocks.append(adapter.toCellItem(.mock))
        }
        
        return ImagesListState(
            query: "Testing",
            listingItems: itemMocks,
            listingState: .loading
        )
    }
}
