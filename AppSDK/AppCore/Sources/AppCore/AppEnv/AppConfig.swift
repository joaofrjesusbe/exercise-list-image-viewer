import SwiftUI

public struct AppConfig: Sendable {
    /// BCP-47 language codes (e.g., "en", "es", "pt", "pt-BR").
    public var supportedLanguages: [String]
    /// Which theme modes the brand wants to expose in UI.
    public var themeModes: [ThemeMode]

    public init(
        supportedLanguages: [String] = ["en"],
        themeModes: [ThemeMode] = [.system, .light, .dark]
    ) {
        self.supportedLanguages = supportedLanguages
        self.themeModes = themeModes
    }

    public static let `default` = AppConfig()
}
