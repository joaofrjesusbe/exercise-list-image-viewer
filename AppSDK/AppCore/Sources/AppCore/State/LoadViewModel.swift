import SwiftUI
import Combine

@MainActor
open class LoadViewModel<ViewState, Intent>: IntentSendable<Intent>, ObservableObject {
    @Published public private(set) var state: LoadState<ViewState> = .idle
    public let errorMapper: ErrorMapper
    open private(set) var currentLocale: Locale

    public init(errorMapper: ErrorMapper = DefaultErrorMapper(), locale: Locale = .current) {
        self.errorMapper = errorMapper
        self.currentLocale = locale
    }
        
    public func updateLoading() {
        update(.loading)
    }
    
    public func updateViewState(_ value: ViewState) {
        update(.current(value))
    }
    
    public func updateError(_ error: Error) {
        update(.failed(errorMapper.mapError(error)))
    }
    
    public func update(_ newState: LoadState<ViewState>) {
        self.state = newState
    }
    
    open func onChangeLanguage() {
        // react to on change language
    }
    
    public func updateLocale(_ locale: Locale) {
        guard locale != self.currentLocale else { return }
        self.currentLocale = locale
        
        guard state.viewState != nil else { return }
        onChangeLanguage()
    }
}
    

