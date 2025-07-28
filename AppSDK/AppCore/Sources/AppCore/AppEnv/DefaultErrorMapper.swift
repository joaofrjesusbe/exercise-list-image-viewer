import SwiftUI

@MainActor
public struct DefaultErrorMapper: ErrorMapper {
    let languageManager: LanguageManager
    
    public init() {
        languageManager = LanguageManagerKey.defaultValue
    }
    
    public func mapError(_ error: any Error) -> AppCore.ErrorState {
        ErrorState(
            title: L10n.errorTitle,
            description: LocalizedKey(error.localizedDescription),
            icon: nil
        )
    }
}
