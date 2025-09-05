import AppGroup

public protocol ImagePageService {
    
    func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page
}

extension PixbayAPIService: ImagePageService { }

struct MockImagePageService: ImagePageService {
    private let totalItems: Int
    private let pageImages: [[ImageInfo]]

    public init() {
        let pages = 5
        let itemsPerPage: Int = 10
        
        var arrayPages = Array<[ImageInfo]>()
        
        for _ in 0..<pages {
            var arrayItems = Array<ImageInfo>()
            for _ in 0..<itemsPerPage {
                arrayItems.append(.mock)
            }
            arrayPages.append(arrayItems)
        }
        
        self.totalItems = arrayPages.count
        self.pageImages = arrayPages
    }
    
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
            hasNextPage: pageNumber < pageImages.count,
            totalNumberOfItems: totalItems
        )
        return page
    }
}
