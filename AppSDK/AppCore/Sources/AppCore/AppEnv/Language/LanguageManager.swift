import SwiftUI

@MainActor
public final class LanguageManager: ObservableObject {
    @Published public private(set) var currentLanguage: LanguageKey {
        didSet { locale = Locale(identifier: currentLanguage) }
    }

    @Published public private(set) var locale: Locale
    public let supportedLanguages: [LanguageKey]
    public let defaultLanguage: LanguageKey

    public init(supportedLanguages: [LanguageKey], initialLanguage: LanguageKey? = nil) {
        let cleaned = Self.normalize(supportedLanguages)
        self.supportedLanguages = cleaned
        self.defaultLanguage = cleaned.first ?? "en"

        let start = initialLanguage
            .map(Self.normalize(_:))
            .flatMap { Self.bestSupportedMatch(for: $0, in: cleaned) }
            ?? self.defaultLanguage

        self.currentLanguage = start
        self.locale = Locale(identifier: start)
    }

    public func select(code: LanguageKey) {
        let best = Self.bestSupportedMatch(for: Self.normalize(code), in: supportedLanguages) ?? defaultLanguage
        guard best != currentLanguage else { return }
        currentLanguage = best
        objectWillChange.send()
    }

    public func displayName(for code: LanguageKey, in locale: Locale = .current) -> String {
        let lang = Locale(identifier: code).language.languageCode?.identifier ?? code
        return locale.localizedString(forLanguageCode: lang) ?? code.uppercased()
    }

    // MARK: - helpers
    private static func normalize(_ code: String) -> String {
        let loc = Locale(identifier: code)
        let lang = (loc.language.languageCode?.identifier ?? code).lowercased()
        if let region = loc.region?.identifier { return "\(lang)-\(region.uppercased())" }
        return lang
    }
    private static func normalize(_ codes: [String]) -> [String] {
        var seen = Set<String>(), out: [String] = []
        for c in codes {
            let n = normalize(c)
            if seen.insert(n).inserted { out.append(n) }
        }
        return out
    }
    private static func bestSupportedMatch(for code: String, in supported: [String]) -> String? {
        if supported.contains(code) { return code }
        if let base = code.split(separator: "-").first.map(String.init), supported.contains(base) { return base }
        return nil
    }
}
