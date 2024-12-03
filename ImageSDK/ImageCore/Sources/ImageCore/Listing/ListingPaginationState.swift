import Foundation

public enum ListingPaginationState<Error> {
    case idle
    case loading
    case failed(Error)
}
