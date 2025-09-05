import Foundation
import AppGroup

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
    
    var imagePageService: Factory<ImagePageService> {
        Factory(self) { PixbayAPIService() }
    }
    
    @MainActor
    var imageInfoUIAdapter: Factory<ImageInfoUIAdaptable> {
        self { @MainActor in ImageInfoUIAdapter() }
    }
}
