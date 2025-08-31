import SwiftUI

// MARK: - Preview Helpers for LanguageManager
public extension View {
    /// Injects a default `LanguageManager` and syncs SwiftUI's `\.locale`.
    func previewWithLanguage(
        supported: [LanguageKey] = ["en"],
        initial: LanguageKey? = nil
    ) -> some View {
        let languageManager = LanguageManager(
            supportedLanguages: supported,
            initialLanguage: initial
        )

        return self
            .environmentObject(languageManager)
            .environment(\.locale, languageManager.locale)
    }

    /// Duplicates the view once per language and labels each preview with the autonym.
    @ViewBuilder
    func previewInAllLanguages(_ supported: [LanguageKey]) -> some View {
        ForEach(supported, id: \.self) { code in
            let lm = LanguageManager(supportedLanguages: supported, initialLanguage: code)
            self
                .environmentObject(lm)
                .environment(\.locale, lm.locale)
                .previewDisplayName(lm.displayName(for: code))
        }
    }
}
