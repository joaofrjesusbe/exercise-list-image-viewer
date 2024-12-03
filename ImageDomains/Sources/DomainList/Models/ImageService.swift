import ImageIO
import ImageCore

public protocol ImageService {
    
    func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page
}

extension ListImagesNetworkService: ImageService { }

struct MockImageService: ImageService {
    let pageImages: [[ImageInfo]]
    
    func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page {
        guard
            pageNumber > 0,
            pageImages.indices.contains(pageNumber - 1)
        else {
            throw NetworkError.invalidPage(pageNumber)
        }
        
        let pageIndex = pageNumber - 1
        var page = ImageInfoListing.Page(pageNumber: pageNumber, items: pageImages[pageIndex])
        page.totalNumberOfPages = pageImages.count
        page.hasNextPage = pageNumber < pageImages.count
        return page
    }
}
