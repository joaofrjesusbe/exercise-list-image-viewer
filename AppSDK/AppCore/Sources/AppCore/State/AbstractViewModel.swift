import SwiftUI

@MainActor
open class IntentSendable<Intent> {
    
    open func send(_ intent: Intent) {
        fatalError("Subclasses must override send(_:) method")
    }
}

@MainActor
open class AbstractViewModel<ViewState, Intent>: IntentSendable<Intent>, ObservableObject {
    @Published public private(set) var state: LoadState<ViewState> = .idle
    public let errorMapper: ErrorMapper

    public init(errorMapper: ErrorMapper) {
        self.errorMapper = errorMapper
    }
    
    public func updateLoading() {
        update(.loading)
    }
    
    public func updateViewState(_ value: ViewState) {
        update(.didLoad(value))
    }
    
    public func updateError(_ error: Error) {
        update(.failed(errorMapper.mapError(error)))
    }
    
    public func update(_ newState: LoadState<ViewState>) {
        self.state = newState
    }
}
    

