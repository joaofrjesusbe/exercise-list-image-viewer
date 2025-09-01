import Foundation

public struct DefaultErrorMapper: ErrorMapper {
    public init() {}
    
    public func mapError(_ error: Error) -> AppCore.ErrorState {
        let key: LocalizedKey
        let args: [CVarArg] = []
        
        switch error {
        case let url as URLError:
            switch url.code {
            case .notConnectedToInternet:
                key = AppCoreL10n.errorNetworkOffline
            case .timedOut:
                key = AppCoreL10n.errorNetworkTimeout
            default:
                key = AppCoreL10n.errorNetworkGeneric
            }
            
        case is DecodingError:
            key = AppCoreL10n.errorNetworkParsing
            
        case let local as LocalizedError:
            // If the error already provides a user-facing string, pass it through as *plain text*,
            // not as a key. (Adjust to your LocalizedKey API.)
            if let desc = local.errorDescription {
                return ErrorState(
                    title: .key(AppCoreL10n.errorTitle),
                    description: .plain(desc),      // <-- not a key
                    icon: nil
                )
            }
            fallthrough
            
        default:
            key = AppCoreL10n.errorNetworkGeneric
        }
        
        return ErrorState(
            title: .key(AppCoreL10n.errorTitle),
            description: .key(key, arguments: args),
            icon: nil
        )
    }
}
