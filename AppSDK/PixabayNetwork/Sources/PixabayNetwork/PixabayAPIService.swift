import Foundation
import AppCore

public typealias ImageInfoListing = Listing<ImageInfo, Void>

public final class PixabayAPIService {
    @Injected(\.httpClient) var httpClient
    
    public init() {}
    
    public func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page {
        guard
            pageNumber > 0
        else {
            throw NetworkError.invalidPage(pageNumber)
        }
        
        let request = PixabayEndpoint.search(query: query, page: pageNumber)
        
        let (dto, _) = try await httpClient.send(request, decode: ImageListDTO.self)
        let page = ImageInfoListing.Page(
            items: dto.hits,
            pageNumber: pageNumber,
            hasNextPage: dto.hits.count == PixabayEndpoint.defaultPageSize
        )
        return page
    }
}
