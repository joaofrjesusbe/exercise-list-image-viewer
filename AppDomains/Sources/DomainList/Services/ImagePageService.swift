import AppCore
import PixbayNetwork

public protocol ImagePageService {
    
    func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page
}

extension ListImagesNetworkService: ImagePageService { }

struct MockImageService: ImagePageService {
    let pageImages: [[ImageInfo]]
    
    func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page {
        guard
            pageNumber > 0,
            pageImages.indices.contains(pageNumber - 1)
        else {
            throw NetworkError.invalidPage(pageNumber)
        }
        
        let pageIndex = pageNumber - 1
        let page = ImageInfoListing.Page(
            items: pageImages[pageIndex],
            pageNumber: pageNumber,
            hasNextPage: pageNumber < pageImages.count
        )
        return page
    }
}
