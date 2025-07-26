import Foundation
import PixbayNetwork

@MainActor
public struct DomainListDI {
    
    static func createProvider() -> ImageListProvider {
        let service = ListImagesNetworkService()
        let provider = ImageListProvider(query: "Funny", service: service, minimumOffsetToLoadNextPage: 5)
        return provider
    }
    
    static func createImageList(provider: ImageListProvider = createProvider()) -> ImagesListFeature {
        let viewModel = ImagesListViewModel(provider: provider)
        let view = ImagesListFeature(viewModel: viewModel)
        return view
    }
    
    static func createImageDetail(detail: ImageInfo) -> ImageDetailFeature {
        let view = ImageDetailFeature(imageInfo: detail)
        return view
    }
}
