import Foundation

public enum L10n {
    public static let retry = LocalizedStringResource(
        "state.retry",
        defaultValue: "Retry",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Retry button for fail operation"
    )
    
    public static let loading = LocalizedStringResource(
        "state.loading",
        defaultValue: "Loading",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Loading message for an operation"
    )
    
    public static let errorTitle = LocalizedStringResource(
        "error.title",
        defaultValue: "Error",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Generic Error title for alert"
    )
    
    public static let errorNetworkOffline = LocalizedStringResource(
        "error.network.offline",
        defaultValue: "Network not available",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Description of offline network error"
    )
    
    public static let errorNetworkTimeout = LocalizedStringResource(
        "error.network.timeout",
        defaultValue: "Server is not responding",
        bundle: .atURL(Bundle.module.bundleURL),
        comment:  "Description of server timeout network error"
    )
    
    public static let errorNetworkGeneric = LocalizedStringResource(
        "error.network.generic",
        defaultValue: "Something went wrong",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Description of a network error"
    )
    
    public static let errorNetworkParsing = LocalizedStringResource(
        "error.network.parsing",
        defaultValue: "Server send invalid data",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Unrecognized response from the server. Unable to parse correctly."
    )
}
