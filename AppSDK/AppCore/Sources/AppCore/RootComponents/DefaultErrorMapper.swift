import Foundation

public struct DefaultErrorMapper: ErrorMapper {
    public init() {}

    public func mapError(_ error: Error) -> AppCore.ErrorState {
        let key: String
        let args: [CVarArg] = []

        switch error {
        case let url as URLError:
            switch url.code {
            case .notConnectedToInternet: key = "error.network.offline"
            case .timedOut:               key = "error.network.timeout"
            default:                      key = "error.network.generic"
            }

        case is DecodingError:
            key = "error.parsing"

        case let local as LocalizedError:
            // If the error already provides a user-facing string, pass it through as *plain text*,
            // not as a key. (Adjust to your LocalizedKey API.)
            if let desc = local.errorDescription {
                return ErrorState(
                    title: .key("error.title"),
                    description: .plain(desc),      // <-- not a key
                    icon: nil
                )
            }
            fallthrough

        default:
            key = "error.generic"
        }

        return ErrorState(
            title: .key("error.title"),
            description: .key(key, arguments: args),
            icon: nil
        )
    }
}
