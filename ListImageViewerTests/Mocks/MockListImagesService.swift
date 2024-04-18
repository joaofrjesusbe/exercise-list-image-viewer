import Foundation
@testable import ListImageViewer

class MockListImagesService: ListImagesService {

        var invokedRequestPage = false
        var invokedRequestPageCount = 0
        var invokedRequestPageParameters: (query: String, page: Int)?
        var invokedRequestPageParametersList = [(query: String, page: Int)]()
        var stubbedRequestPageResult: ListingPage<ImageInfo, Void>!
        var stubbedRequestPageError: Error?
        
        func requestPage(query: String, page: Int) async throws -> ListingPage<ImageInfo, Void> {
            invokedRequestPage = true
            invokedRequestPageCount += 1
            invokedRequestPageParameters = (query, page)
            invokedRequestPageParametersList.append((query, page))
            if let error = stubbedRequestPageError {
                throw error
            }
            return stubbedRequestPageResult
        }
}
