import SwiftUI
import AppCore

public struct MockErrorMapper: ErrorMapper {
    
    public init() {}
    
    public func mapError(_ error: any Error) -> AppCore.ErrorState {
        ErrorState(
            title: L10n.errorTitle,
            description: LocalizedKey(error.localizedDescription),
            icon: nil
        )
    }
}
