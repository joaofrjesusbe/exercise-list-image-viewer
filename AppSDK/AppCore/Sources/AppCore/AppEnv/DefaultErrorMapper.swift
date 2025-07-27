import SwiftUI

public struct DefaultErrorMapper: ErrorMapper {
    
    public init() {}
    
    public func mapError(_ error: any Error) -> AppCore.ErrorState {
        ErrorState(
            title: L10n.errorTitle,
            description: LocalizedKey(error.localizedDescription),
            icon: nil
        )
    }
}
