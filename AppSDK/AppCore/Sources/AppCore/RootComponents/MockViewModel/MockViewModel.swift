import Foundation

public enum MockIntent {
    case loadData
}

public struct MockError: Error { }

public extension Error {
    static var mock: MockError {
        MockError()
    }
}

public final class MockIntentSendable<Intent>: IntentSendable<Intent> {
    public typealias SelfType = MockIntentSendable<Intent>
    public typealias OnIntent = (Intent, SelfType) -> Void
    
    private let onIntent: OnIntent?
    
    public init(onIntent: OnIntent? = nil) {
        self.onIntent = onIntent
    }
    
    public override func send(_ intent: Intent) {
        print(intent)
        onIntent?(intent, self)
    }
}

public final class MockViewModel<ViewState, Intent>: LoadViewModel<ViewState, Intent> {
    public typealias SelfType = MockViewModel<ViewState, Intent>
    public typealias OnIntent = (Intent, SelfType) -> Void
    
    private let onIntent: OnIntent?
    
    public convenience init(viewState: ViewState, onIntent: OnIntent? = nil) {
        self.init(loadState: .idle, onIntent: onIntent)
        updateViewState(viewState)
    }
    
    public convenience init(error: Error, errorMapper: any ErrorMapper = DefaultErrorMapper()) {
        self.init(loadState: .idle, errorMapper: errorMapper)
        updateError(error)
    }
    
    public convenience init() {
        self.init(loadState: .loading)
    }
    
    public init(loadState: LoadState<ViewState>, onIntent: OnIntent? = nil, errorMapper: any ErrorMapper = DefaultErrorMapper()) {
        self.onIntent = onIntent
        super.init(errorMapper: errorMapper)
        update(loadState)
    }
    
    public override func send(_ intent: Intent) {
        print(intent)
        onIntent?(intent, self)
    }
}
