import SwiftUI
import ImageCore
import ImageDS

@MainActor
final class ImageListViewModel: ObservableObject {
    @Published private(set) var query: String = ""
    @Published private(set) var items: [DSListCell.Item] = []
    @Published private(set) var state: ViewState<Void, String> = .idle
    @Published private(set) var pageState: ListingPaginationState<String> = .idle
    
    private let model: ImageModel
    
    init (model: ImageModel) {
        self.model = model
        
        model.$query.assign(to: &$query)
        model.$currentListing
            .map {
                $0.items.map {
                    MapImageInfo.toCell($0)
                }
            }
            .assign(to: &$items)
    }
    
    func initialLoad() {
        guard items.isEmpty else { return }
        
        Task { @MainActor in
            state = .loading
            do {
                try await model.initialLoad()
                state = .didLoad(())
            } catch let error as NetworkError {
                state = .failed(error.debugDescription)
            } catch {
                state = .failed("Unknown error")
            }
        }
    }
    
    func tryToLoadNextPage(index: Int) {
        if model.shouldLoadNextPage(index: index) {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        Task { @MainActor in
            pageState = .loading
            do {
                try await model.loadNextPage()
                state = .didLoad(())
                pageState = .idle
            } catch let error as NetworkError {
                pageState = .failed(error.debugDescription)
            } catch {
                pageState = .failed("Unknown error")
            }
        }
    }
    
    func modelForIndex(_ index: Int) -> ImageInfo {
        model.currentListing.items[index]
    }
}
