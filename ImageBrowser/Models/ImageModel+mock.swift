import Foundation

extension ImageModel {
    static var mock: ImageModel {
        ImageModel(
            query: "Query",
            provider: MockImageService(pageImages: [[.mock, .mock, .mock], [.mock, .mock, .mock]]),
            minimumOffsetToLoadNextPage: 2
        )
    }
    
    static var mockPageLoaded: ImageModel {
        let mock = mock
        Task {
            try await mock.loadNextPage()
        }
        return mock
    }
}
