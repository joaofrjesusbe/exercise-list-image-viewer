import SwiftUI
import Combine

@MainActor
open class IntentSendable<Intent> {
    
    open func send(_ intent: Intent) {
        fatalError("Subclasses must override send(_:) method")
    }
}

@MainActor
open class LoadViewModel<ViewState, Intent>: IntentSendable<Intent>, ObservableObject {
    @Published public private(set) var state: LoadState<ViewState> = .idle
    public let errorMapper: ErrorMapper
    public let languageManager: LanguageManager
    private var cancellables = Set<AnyCancellable>()

    public init(errorMapper: ErrorMapper = DefaultErrorMapper()) {
        self.errorMapper = errorMapper
        self.languageManager = LanguageManagerKey.defaultValue
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
    
    open func onChangeLanguageManager() {
        // react to on change language
    }
    
    private func observeLanguageChanges() {
        languageManager.$currentLanguage
            .sink { [weak self] _ in
                self?.onChangeLanguageManager()
            }
            .store(in: &cancellables)
        
        languageManager.$locale
            .sink { [weak self] _ in
                self?.onChangeLanguageManager()
            }
            .store(in: &cancellables)
    }
}
    

