import Foundation

public typealias LoadState<ViewState> = AnyLoadState<ViewState, ErrorState>

public enum AnyLoadState<ViewState, ErrorState> {
    case idle
    case loading
    case current(ViewState)
    case failed(ErrorState)
}

extension AnyLoadState: Sendable where ViewState: Sendable, ErrorState: Sendable {}

public extension AnyLoadState {
    var isWaiting: Bool {
        switch self {
        case .loading, .idle:
            return true
        default:
            return false
        }
    }

    var viewState: ViewState? {
        switch self {
        case .current(let viewState):
            return viewState
        default:
            return nil
        }
    }

    var failedState: ErrorState? {
        switch self {
        case .failed(let object):
            return object
        default:
            return nil
        }
    }
}

public extension AnyLoadState where ViewState == Void {
    
    static var currentVoid: Self {
        return .current(())
    }
}
