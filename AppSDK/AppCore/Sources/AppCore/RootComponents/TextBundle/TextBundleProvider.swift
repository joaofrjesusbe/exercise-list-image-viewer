import SwiftUI

public struct TextBundleProvider<Content: View>: View {
    @Environment(\.locale) private var locale
    @Environment(\.l10nOverrideBundles) private var overrideBundles
    
    private let resource: LocalizedStringResource
    private let content: (Text) -> Content

    public init(_ resource: LocalizedStringResource, @ViewBuilder content: @escaping (Text) -> Content) {
        self.resource = resource
        self.content = content
    }

    public var body: some View {
        let text = TextBundleFactory(resource: resource, locale: locale, overrideBundles: overrideBundles)()
        content(text)
    }
}

struct TextBundleProvider_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        TextBundleProvider(L10n.errorTitle, content: { text in
            text
                .bold()
                .kerning(1)
        })
    }
}
