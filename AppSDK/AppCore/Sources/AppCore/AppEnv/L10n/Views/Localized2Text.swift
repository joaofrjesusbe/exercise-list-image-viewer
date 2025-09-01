import SwiftUI

public struct Localized2Text: View {
    @Environment(\.locale) private var locale
    @Environment(\.l10nOverrideBundles) private var overrideBundles

    private let key: L10n.Key

    public init(_ key: L10n.Key) {
        self.key = key
    }

    public var body: Text {
        Text(L10n.resolve(key, locale: locale, overrideBundles: overrideBundles))
    }
}

#Preview {
    Localized2Text(.init("hello"))
        .bold()
        .kerning(1)        
}
