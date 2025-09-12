import SwiftUI

public typealias Action = () -> Void

public typealias SystemImageName = String

public typealias ListingLoadState = LoadState<Unit>

public struct Unit: Equatable { public init() {} }

public extension AnyLoadState where ViewState == Unit {
    
    static var current: Self {
        return .current(Unit())
    }
}
