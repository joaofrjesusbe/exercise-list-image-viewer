@testable import AppCore
import Foundation
import Testing

@MainActor
final class AppEnvironmentTests: @unchecked Sendable {

    private func makeSuite() -> UserDefaults {
        let suiteName = "AppEnvironmentTests." + UUID().uuidString
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    @Test
    func initializes_with_defaults_and_persists_on_change() {
        let defaults = makeSuite()

        // Given a config with two languages
        let config = AppConfig(supportedLanguages: [.en, .ptPortugal])
        var env: AppEnvironment? = AppEnvironment(config: config, defaults: defaults)

        // Starts with first supported language and system theme
        #expect(env?.languageManager.currentLanguage == .en)
        #expect(env?.themeManager.mode == .system)

        // When updating language and theme
        env?.languageManager.select(language: .ptPortugal)
        env?.themeManager.mode = .dark

        // Then creating a new environment over the same defaults picks up persisted values
        env = nil
        let env2 = AppEnvironment(config: config, defaults: defaults)
        #expect(env2.languageManager.currentLanguage == .ptPortugal)
        #expect(env2.themeManager.mode == .dark)
    }

    @Test
    func picks_up_preseeded_defaults_on_init() {
        let defaults = makeSuite()

        // Pre-seed raw values (black-box: we use the plain keys used internally)
        defaults.set("pt-PT", forKey: "appLanguage")
        defaults.set("light", forKey: "themeMode")

        let config = AppConfig(supportedLanguages: [.en, .ptPortugal])
        let env = AppEnvironment(config: config, defaults: defaults)

        #expect(env.languageManager.currentLanguage == .ptPortugal)
        #expect(env.themeManager.mode == .light)
    }
}

