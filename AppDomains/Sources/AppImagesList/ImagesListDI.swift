import Foundation
import AppGroup

@MainActor
public struct ImagesListDI {
    
    static func getImagesListViewModel() -> ImagesListViewModel {
        let provider = Container.shared.imageListProvider
        return ImagesListViewModel(provider: provider)
    }
    
    static func getImageDetail(index: Int) -> ImageInfo {
        let provider = Container.shared.imageListProvider
        return provider.currentListing.items[index]
    }
}

extension Container {
    
    @MainActor
    var imageListProvider: ImageListProvidable {
        self { @MainActor in ImageListProvider(query: "Funny", minimumOffsetToLoadNextPage: 5) }.singleton()
    }
    
    var imagePageService: Factory<ImagePageService> {
        self { PixbayAPIService() }
    }
    
    @MainActor
    var imageInfoUIAdapter: Factory<ImageInfoUIAdaptable> {
        self { @MainActor in ImageInfoUIAdapter() }
    }
}
