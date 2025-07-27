import Foundation
import AppCore

public typealias ImageInfoListing = Listing<ImageInfo, Void>

public final class PixbayAPIService {
    private let session: URLSession
    private let logger: Logger
    
    public init(session: URLSession = .shared, logger: Logger) {
        self.session = session
        self.logger = logger
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
        
        logger.network("url:\n\(url.absoluteString)")
        
        do {
            let (data, _) = try await session.data(from: url)
            logger.debug(json: data)
            let listImages = try JSONDecoder().decode(ImageListDTO.self, from: data)
            let page = ImageInfoListing.Page(
                items: listImages.hits,
                pageNumber: pageNumber,
                hasNextPage: listImages.hits.count == PixbayEndpoint.defaultPageSize
            )
            return page
        } catch {
            logger.error(error.localizedDescription)
            throw error
        }
    }
}
