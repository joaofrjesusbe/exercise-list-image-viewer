import SwiftUI

public struct AppConfig: Sendable {
    /// BCP-47 language codes (e.g., "en", "es", "pt", "pt-BR").
    public var supportedLanguages: [LanguageCode]
    
    public init(
        supportedLanguages: [LanguageCode] = LanguageCode.allCases
    ) {
        self.supportedLanguages = supportedLanguages
    }

    public static let `default` = AppConfig()
}
