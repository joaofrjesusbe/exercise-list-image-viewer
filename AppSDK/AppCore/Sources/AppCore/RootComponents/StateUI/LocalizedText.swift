import SwiftUI

public struct LocalizedText: View {
    @EnvironmentObject private var languageManager: LanguageManager
    private let value: LocalizedString
    
    public init(_ value: LocalizedString) {
        self.value = value
    }
    
    public var body: some View {
        switch value {
        case .plain(let string):
            Text(string)
        case .key(let key, let arguments):
            if arguments.isEmpty {
                key.asTextView
            } else {
                // Fetch the localized *format* string for the selected locale, then format with args.
                //  let format = String(localized: .init(key), bundle: .main, locale: languageManager.locale)
                //Text(String(format: format, locale: languageManager.locale, arguments))
            }
        }
    }
}
