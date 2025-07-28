
import SwiftUI

@MainActor
public final class LanguageManager: ObservableObject {
    @Published var currentLanguage: LanguageKey {
        didSet {
            locale = Locale(identifier: currentLanguage)
        }
    }

    @Published public private(set) var locale: Locale
    public let supportedLanguages: [LanguageKey]

    public init(supportedLanguages: [LanguageKey]) {
        let defaultLanguage = supportedLanguages.first ?? "en"
        self.currentLanguage = defaultLanguage
        self.supportedLanguages = supportedLanguages
        self.locale = Locale(identifier: defaultLanguage)
    }
}

@MainActor
public struct LanguageManagerKey: @preconcurrency EnvironmentKey {
    public static let defaultValue: LanguageManager = LanguageManager(supportedLanguages: ["en"])
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageManagerKey.self] }
        set { self[LanguageManagerKey.self] = newValue }
    }
}
