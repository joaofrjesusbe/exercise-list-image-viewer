import SwiftUI

@MainActor
public enum AppCoreL10n {
    public static let retry = LocalizedKey("state.retry")
    public static let loading = LocalizedKey("state.loading")
    
    public static let errorTitle = LocalizedKey("error.title")
    public static let errorNetworkOffline = LocalizedKey("error.network.offline")
    public static let errorNetworkTimeout = LocalizedKey("error.network.timeout")
    public static let errorNetworkGeneric = LocalizedKey("error.network.generic")
    public static let errorNetworkParsing = LocalizedKey("error.network.parsing")                
}
