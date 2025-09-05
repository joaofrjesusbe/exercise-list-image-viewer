import Foundation

public enum LanguageCode: String, CaseIterable, Sendable {
    case en = "en"
    case ptPortugal = "pt-PT"
    
    static let defaultLanguage = LanguageCode.en
}

