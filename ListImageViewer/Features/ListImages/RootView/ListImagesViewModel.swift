import SwiftUI

enum ListImagesViewState: Equatable {
    case loading
    case images([ImageInfoUI])
    case failed
}

@Observable
final class ListImagesViewModel {
    private(set) var state: ListImagesViewState = .loading
    private(set) var paginationState: ListingPaginationState = .idle
    private let action: NextImagesPageAction

    init(action: NextImagesPageAction) {
        self.action = action
    }

    func loadImages() async {
        state = .loading
        do {
            let items = try await action().map { $0.toImageInfoUIModel() }
            state = .images(items)
        } catch {
            state = .failed
        }
    }

    func itemDidAppear(index: Int) {
        guard action.canExecute(itemIndex: index) else {
            return
        }

        Task {
            paginationState = .loading
            do {
                let items = try await action().map { $0.toImageInfoUIModel() }
                state = .images(items)
                paginationState = .idle
            } catch {
                paginationState = .failed
            }
        }
    }
}
