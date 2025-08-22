import SwiftUI

public struct LocalizedKey: ExpressibleByStringLiteral, Sendable {
    private let rawValue: String

    public init(_ raw: String) { self.rawValue = raw }
    public init(stringLiteral value: StringLiteralType) { self.rawValue = value }

    /// Resolve to a localized String from your .xcstrings/.strings files.
    public func toLocalized(
        bundle: Bundle = .main,
        tableName: String? = nil,
        locale: Locale = .current
    ) -> String {
        // NOTE: String(localized:) expects a String.LocalizationValue
        String(
            localized: .init(rawValue),
            table: tableName,
            bundle: bundle,
            locale: locale
        )
    }

    /// For SwiftUI `Text`, use this to keep SwiftUI’s formatting behavior.
    public var asLocalizedKey: LocalizedStringKey { LocalizedStringKey(rawValue) }

    /// Convenience if you often need `Text`.
    public var asTextView: Text { Text(asLocalizedKey) }
}
