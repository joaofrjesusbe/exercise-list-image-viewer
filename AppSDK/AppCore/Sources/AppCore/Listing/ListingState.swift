import Foundation

public typealias ListingState = LoadState<Void>

public extension ListingState {
    
    static var didLoadVoid: ListingState {
        return .didLoad(())
    }
}
