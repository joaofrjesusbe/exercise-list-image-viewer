import SwiftUI

public struct LocalizedTextProvider<Content: View>: View {
    @Environment(\.locale) private var locale
    @Environment(\.l10nOverrideBundles) private var overrideBundles
    
    private let key: L10n.Key
    private let content: (Text) -> Content

    public init(_ key: L10n.Key, @ViewBuilder content: @escaping (Text) -> Content) {
        self.key = key; self.content = content
    }

    public var body: some View {
        let t = Text(L10n.resolve(key, locale: locale, overrideBundles: overrideBundles))
        content(t) // you can use Text-only APIs here
    }
}

#Preview {
    LocalizedTextProvider(.init(stringLiteral: "Helloworld")) { text in
        text.kerning(1).bold().italic()
    }
}
