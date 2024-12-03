import SwiftUI
import ImageCore

@MainActor
class ImageListLoaderAdapter: ObservableObject {
    @Published var state: ViewState<Void, String> = .idle {
        didSet {
            pageState = .idle
        }
    }
    @Published var pageState: ListingPaginationState<String> = .idle
    private var model: ImageModel?
    
    func initialLoad(model: ImageModel) {
        self.model = model
        state = .loading
        
        Task { @MainActor in
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
    
    func loadNextPage() {
        guard let model else { return }
        
        Task { @MainActor in
            pageState = .loading
            do {
                try await model.loadNextPage()
                pageState = .idle
            } catch let error as NetworkError {
                pageState = .failed(error.debugDescription)
            } catch {
                pageState = .failed("Unknown error")
            }
        }
    }
    
    func tryToLoadNextPage(index: Int) {
        guard let model else { return }
        if model.shouldLoadNextPage(index: index) {
            loadNextPage()
        }
    }
}
