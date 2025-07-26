import Foundation
import PixbayNetwork

@MainActor
public struct ImagesListDI {

    static func createProvider() -> ImageListProvider {
        let service = PixbayAPIService()
        let provider = ImageListProvider(query: "Funny", service: service, minimumOffsetToLoadNextPage: 5)
        return provider
    }
    
    static func createImageListViewModel(provider: ImageListProvider = createProvider()) -> ImagesListViewModel {
        let viewModel = ImagesListViewModel(provider: provider)
        return viewModel
    }
}
