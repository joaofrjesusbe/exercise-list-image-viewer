import Foundation
import AppCore

public typealias ImageInfoListing = Listing<ImageInfo, Void>

public final class PixbayAPIService {
    private let defaultPageSize: Int
    private let session: URLSession

    public init(session: URLSession = .shared, defaultPageSize: Int = 20) {
        self.session = session
        self.defaultPageSize = defaultPageSize
    }

    public func requestPage(query: String, pageNumber: Int) async throws -> ImageInfoListing.Page {
        guard let url = PixbayEndpoint.search(query: query, page: pageNumber).url else {
            throw NetworkError.urlMalform
        }

        do {
            let (data, _) = try await session.data(from: url)
            let listImages = try JSONDecoder().decode(ImageListDTO.self, from: data)
            let page = ImageInfoListing.Page(
                items: listImages.hits,
                pageNumber: pageNumber,
                hasNextPage: listImages.hits.count == defaultPageSize
            )
            return page

        } catch let error {
            print("Error \(error.localizedDescription)")
            throw NetworkError.invalidPage(pageNumber)
        }
    }
}
