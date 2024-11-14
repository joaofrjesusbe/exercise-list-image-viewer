import Foundation
import ImageCore

public typealias ImageInfoListing = Listing<ImageInfo, Void>

public final class ListImagesNetworkService {
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
            let listImages = try JSONDecoder().decode(ImageListRTO.self, from: data)
            var page = ImageInfoListing.Page(pageNumber: pageNumber, items: listImages.hits)
            page.hasNextPage = listImages.hits.count == defaultPageSize
            return page

        } catch let error {
            print("Error \(error.localizedDescription)")
            throw NetworkError.invalidPage(pageNumber)
        }
    }
}
