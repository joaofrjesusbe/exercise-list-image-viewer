@testable import AppCore
import Foundation
import Testing

@MainActor
final class LanguageDisplayTests: @unchecked Sendable {

    @Test
    func autonym_en_returns_English() {
        let value = LanguageDisplay.autonym(for: "en")
        #expect(value == "English")
    }

    @Test
    func localized_to_en_shows_region_and_normalizes_underscore() {
        // "pt_BR" should be normalized to BCP-47 and localized to English
        let en = Locale(identifier: "en")
        let value1 = LanguageDisplay.name(for: "pt-BR", localizedTo: en, showRegion: true)
        let value2 = LanguageDisplay.name(for: "pt_BR", localizedTo: en, showRegion: true)
        #expect(value1 == "Portuguese (Brazil)")
        #expect(value2 == "Portuguese (Brazil)")
    }

    @Test
    func autonym_without_region_hides_parenthetical() {
        let value = LanguageDisplay.autonym(for: "pt-PT", showRegion: false)
        #expect(!value.contains("("))
        #expect(!value.isEmpty)
    }
}

