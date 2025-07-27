import Foundation
import AppCore

public typealias ImageInfoListing = Listing<ImageInfo, Void>

public final class PixbayAPIService {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page {
        guard let url = PixbayEndpoint.search(query: query, page: pageNumber).url else {
            throw NetworkError.urlMalform
        }
        
        guard
            pageNumber > 0
        else {
            throw NetworkError.invalidPage(pageNumber)
        }
        
        let (data, _) = try await session.data(from: url)
        let listImages = try JSONDecoder().decode(ImageListDTO.self, from: data)
        let page = ImageInfoListing.Page(
            items: listImages.hits,
            pageNumber: pageNumber,
            hasNextPage: listImages.hits.count == PixbayEndpoint.defaultPageSize
        )
        return page
    }
}
