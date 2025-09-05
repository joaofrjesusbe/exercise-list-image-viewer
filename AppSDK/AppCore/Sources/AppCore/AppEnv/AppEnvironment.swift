import SwiftUI
import Combine

@MainActor
public final class AppEnvironment: ObservableObject {
    private enum Keys {
        static let themeMode = "themeMode"
        static let appLanguage = "appLanguage"
    }

    // Managers
    public let themeManager: ThemeManager
    public let languageManager: LanguageManager
    public let log: Logger

    // Config + persistence
    private let config: AppConfig
    private let defaults: UserDefaults
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(config: AppConfig = .default, defaults: UserDefaults = .standard, log: Logger = ConsoleLogger()) {
        self.config = config
        self.defaults = defaults
        self.log = log

        self.languageManager = LanguageManager(supportedLanguages: config.supportedLanguages)
        
        // Restore persisted language (falls back to first supported)
        if
            let persistedLang = defaults.string(forKey: Keys.appLanguage),
            let language = LanguageCode(rawValue: persistedLang)
        {
            self.languageManager.select(language: language)
        }

        // Restore persisted theme mode and clamp to allowed modes
        let persistedMode = defaults.string(forKey: Keys.themeMode)
            .flatMap(ThemeMode.init(rawValue:)) ?? .system

        let initialMode = persistedMode
        self.themeManager = ThemeManager(log: log, mode: initialMode)
        
        bridgeChildPublishers()
        setEnvPersistance()
    }
    
    private func bridgeChildPublishers() {
        // Bridge child publishers so views update when either manager changes.
        themeManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        languageManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    private func setEnvPersistance() {
        themeManager.$mode
            .removeDuplicates()
            .sink { [weak defaults] mode in
                defaults?.set(mode.rawValue, forKey: Keys.themeMode)
            }
            .store(in: &cancellables)

        // Assumes LanguageManager exposes a published selected language/code.
        // Adjust the key path to match your API (e.g., `$selected.code`, `$current.code`, or `$selectedCode`).
        languageManager.$currentLanguage
            .removeDuplicates()
            .sink { [weak defaults] code in
                defaults?.set(code.rawValue, forKey: Keys.appLanguage)
            }
            .store(in: &cancellables)

        // Write the initial/restored values once so defaults are immediately in sync.
        defaults.set(themeManager.mode.rawValue, forKey: Keys.themeMode)
        defaults.set(languageManager.currentLanguage.rawValue, forKey: Keys.appLanguage) // adjust if needed
    }
}
