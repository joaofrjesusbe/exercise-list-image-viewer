import SwiftUI

@MainActor
public final class LanguageManager: ObservableObject {
    @Published public private(set) var currentLanguage: LanguageCode {
        didSet { locale = Locale(identifier: currentLanguage.rawValue) }
    }

    @Published public private(set) var locale: Locale
    public let supportedLanguages: [LanguageCode]
    public let defaultLanguage: LanguageCode

    public init(supportedLanguages: [LanguageCode], initialLanguage: LanguageCode? = nil) {
        self.supportedLanguages = supportedLanguages
        self.defaultLanguage = supportedLanguages.first ?? .defaultLanguage

        let start = initialLanguage ?? self.defaultLanguage

        self.currentLanguage = start
        self.locale = Locale(identifier: start.rawValue)
    }

    public func select(language: LanguageCode) {
        guard language != currentLanguage else { return }
        currentLanguage = language
        objectWillChange.send()
    }

    public func displayName(for language: LanguageCode) -> String {
        LanguageDisplay.autonym(for: language.rawValue)
    }
}
