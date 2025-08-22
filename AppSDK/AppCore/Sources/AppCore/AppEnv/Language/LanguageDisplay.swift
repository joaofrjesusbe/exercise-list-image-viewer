import Foundation

public struct LanguageDisplay {
    public enum Style: Equatable, Sendable {
        case current                // Name in the app's current language
        case autonym                // Name in the language’s own language
        case localized(Locale)      // Name localized to a specific locale
    }

    @inline(__always)
    private static func normalize(_ code: String) -> String {
        // Normalize separators (e.g., "pt_BR" → "pt-BR")
        let cleaned = code.replacingOccurrences(of: "_", with: "-")
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            // Canonicalize to a proper BCP-47 identifier
            return Locale.identifier(.bcp47, from: cleaned)
        } else {
            // Fallback for older OS versions
            return NSLocale.canonicalLocaleIdentifier(from: cleaned)
        }
    }

    /// Returns a display name for a BCP-47 language code (e.g., "pt", "en", "pt-BR", "zh-Hans").
    public static func name(
        for code: String,
        style: Style = .autonym,
        showRegion: Bool = true
    ) -> String {
        let id = normalize(code)

        let baseLocale: Locale = {
            switch style {
            case .current: return .current
            case .autonym: return Locale(identifier: id) // autonym
            case .localized(let loc): return loc
            }
        }()

        let result: String? = {
            if showRegion {
                // e.g., "Português (Brasil)"
                return baseLocale.localizedString(forIdentifier: id)
            } else {
                // Only the language subtag (e.g., "Português")
                if let lang = id.split(whereSeparator: { $0 == "-" || $0 == "_" }).first {
                    return baseLocale.localizedString(forLanguageCode: String(lang))
                }
                return nil
            }
        }()

        // Capitalize according to the target locale (Apple sometimes returns lowercase)
        return result?.capitalized(with: baseLocale) ?? code.uppercased()
    }

    // Convenience helpers
    public static func autonym(for code: String, showRegion: Bool = true) -> String {
        name(for: code, style: .autonym, showRegion: showRegion)
    }

    public static func currentLocaleName(for code: String, showRegion: Bool = true) -> String {
        name(for: code, style: .current, showRegion: showRegion)
    }

    public static func name(for code: String, localizedTo locale: Locale, showRegion: Bool = true) -> String {
        name(for: code, style: .localized(locale), showRegion: showRegion)
    }
}
