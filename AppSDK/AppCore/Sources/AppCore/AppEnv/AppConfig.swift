import SwiftUI

public struct AppConfig: Sendable {
    /// BCP-47 language codes (e.g., "en", "es", "pt", "pt-BR").
    public var supportedLanguages: [String]
    
    public init(
        supportedLanguages: [String] = ["en"]
    ) {
        self.supportedLanguages = supportedLanguages
    }

    public static let `default` = AppConfig()
}
