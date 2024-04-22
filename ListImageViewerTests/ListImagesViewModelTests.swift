import XCTest
@testable import ListImageViewer

final class ListImagesViewModelTests: XCTestCase {
    var mockService: MockListImagesService!
    var sut: ListImagesViewModel!

    override func setUpWithError() throws {
        mockService = MockListImagesService()
        sut = ListImagesFeature.createViewModel(service: mockService)
    }

    func testFirstPage() async throws {
        // Given
        let resultImages: [ImageInfo] = [
            .mock,
            .mock
        ]
        mockService.stubbedRequestPageResult = ListingPage(
            pageNumber: 0,
            items: resultImages,
            metadata: Void()
        )

        // When
        await sut.loadImages()

        // Then
        let expectedImages = resultImages.map(ImageInfoUI.init)
        XCTAssertEqual(sut.state, .images(expectedImages))
    }

}
