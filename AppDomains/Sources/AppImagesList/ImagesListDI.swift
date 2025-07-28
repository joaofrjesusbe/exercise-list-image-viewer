import Foundation
import AppCore
import FactoryKit
import PixbayNetwork

@MainActor
public struct ImagesListDI {
    static let sharedProvider: ImageListProvider = {
        let initialQuery = "Funny"
        return ImageListProvider(query: initialQuery, minimumOffsetToLoadNextPage: 5)
    }()
    
    static func createImageListViewModel() -> ImagesListViewModel {
        let viewModel = ImagesListViewModel(provider: sharedProvider)
        return viewModel
    }
    
    static func getImageDetail(index: Int) -> ImageInfo {
        let provider = sharedProvider
        return provider.currentListing.items[index]
    }
}

extension Container {
    
    var logger: Factory<Logger> {
        Factory(self) { ConsoleLogger() }
    }
    
    var imagePageService: Factory<ImagePageService> {
        Factory(self) { PixbayAPIService(logger: self.logger.resolve()) }
    }
    
    @MainActor
    var imageInfoUIAdapter: Factory<ImageInfoUIAdaptable> {
        self { @MainActor in ImageInfoUIAdapter() }
    }
}
