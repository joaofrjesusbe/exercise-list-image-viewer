import Foundation
import AppCore
import FactoryKit
import PixbayNetwork

@MainActor
public struct ImagesListDI {
    
    static func createImageListViewModel(initialQuery: String = "Funny") -> ImagesListViewModel {
        let provider = ImageListProvider(query: initialQuery, minimumOffsetToLoadNextPage: 5)
        let viewModel = ImagesListViewModel(provider: provider)
        return viewModel
    }
}

extension Container {
    
    var logger: Factory<Logger> {
        Factory(self) { ConsoleLogger() }
    }
    
    var imagePageService: Factory<ImagePageService> {
        Factory(self) { PixbayAPIService(logger: self.logger.resolve()) }
    }
}
