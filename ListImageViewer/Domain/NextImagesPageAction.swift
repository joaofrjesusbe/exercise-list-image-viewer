import Foundation

protocol ListImagesService: ListingService
where Query == String, Item == ImageInfo, Metadata == Void { }

protocol ListImagesRepository: ListingRepository 
where Service: ListImagesService { }

struct NextImagesPageAction {
    private let repository: any ListImagesRepository

    init(repository: any ListImagesRepository) {
        self.repository = repository
    }

    public func canExecute(itemIndex: Int) -> Bool {
        repository.shouldLoadNextPage(index: itemIndex)
    }

    public func callAsFunction() async throws -> [ImageInfo] {
        let listing = try await repository.loadNextPage()
        return listing.items
    }
}
