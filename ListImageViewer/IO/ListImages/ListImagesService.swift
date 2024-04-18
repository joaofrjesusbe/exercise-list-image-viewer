import Foundation

final class ListImagesNetworkService: ListImagesService {
    private let defaultPageSize: Int
    private let session: URLSession

    init(session: URLSession = .shared, defaultPageSize: Int = 20) {
        self.session = session
        self.defaultPageSize = defaultPageSize
    }

    func requestPage(query: String, page: Int) async throws -> ListingPage<ImageInfo, Void> {
        guard let url = PixbayEndpoint.search(query: query, page: page).url else {
            throw NetworkError.urlMalform
        }

        do {
            let (data, _) = try await session.data(from: url)
            let listImages = try JSONDecoder().decode(ListImagesDTO.self, from: data)
            var page = AssociatedListingPage(pageNumber: page, items: listImages.hits)
            page.hasNextPage = listImages.hits.count == defaultPageSize
            return page

        } catch let error {
            print("Error \(error.localizedDescription)")
            throw NetworkError.general
        }
    }
}
