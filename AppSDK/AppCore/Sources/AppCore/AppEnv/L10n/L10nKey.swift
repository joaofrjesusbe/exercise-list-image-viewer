import Foundation

public enum L10n {
    public struct Key: Hashable, Sendable, ExpressibleByStringLiteral, Equatable {
        public let raw: String
        public let table: String?
        public let defaultValue: String
        public let bundleHintID: String?   // <- only an id, not a Bundle
        public let arguments: [L10nArg]    // typed, Equatable & Sendable

        public init(_ raw: String,
                    table: String? = nil,
                    defaultValue: String = "",
                    bundleHintID: String? = nil,
                    arguments: [L10nArg] = []) {
            self.raw = raw
            self.table = table
            self.defaultValue = defaultValue
            self.bundleHintID = bundleHintID
            self.arguments = arguments
        }

        public init(stringLiteral value: String) { self.init(value) }

        public func callAsFunction(_ args: L10nArgConvertible...) -> Key {
            .init(raw, table: table, defaultValue: defaultValue,
                  bundleHintID: bundleHintID, arguments: args.map(\.l10nArg))
        }
    }

    /// Resolver: overrides (e.g. .main) → package bundle by `bundleHintID` → default
    public static func resolve(_ key: Key,
                               locale: Locale = .current,
                               overrideBundles: [Bundle] = [.main]) -> String {
        var candidates = overrideBundles
        if let pkg = LocalizationBundles.bundle(for: key.bundleHintID) {
            candidates.append(pkg)
        }

        for bundle in candidates {
            // value:nil lets us detect missing keys (it returns the key itself if missing)
            let format = bundle.localizedString(forKey: key.raw, value: nil, table: key.table)
            if format != key.raw {
                if key.arguments.isEmpty { return format }
                let cArgs: [CVarArg] = key.arguments.map { $0.asCVarArg }
                return String(format: format, locale: locale, arguments: cArgs)
            }
        }

        // Developer fallback
        let dev = key.defaultValue.isEmpty ? key.raw : key.defaultValue
        if key.arguments.isEmpty { return dev }
        let cArgs: [CVarArg] = key.arguments.map { $0.asCVarArg }
        return String(format: dev, locale: locale, arguments: cArgs)
    }
}

