import Foundation

public struct DefaultErrorMapper: ErrorMapper {
    public init() {}
    
    public func mapError(_ error: Error) -> AppCore.ErrorState {
        let key: LocalizedStringResource
        
        switch error {
        case let url as URLError:
            switch url.code {
            case .notConnectedToInternet:
                key = L10n.errorNetworkOffline
            case .timedOut:
                key = L10n.errorNetworkTimeout
            default:
                key = L10n.errorNetworkGeneric
            }
            
        case is DecodingError:
            key = L10n.errorNetworkParsing
            
        case let local as LocalizedError:
            // If the error already provides a user-facing string, pass it through as *plain text*,
            if let desc = local.errorDescription {
                return ErrorState(
                    title: L10n.errorTitle,
                    description: LocalizedStringResource(stringLiteral: desc),
                    icon: nil
                )
            }
            fallthrough
            
        default:
            key = L10n.errorNetworkGeneric
        }
        
        return ErrorState(
            title: L10n.errorTitle,
            description: key,
            icon: nil
        )
    }
}
