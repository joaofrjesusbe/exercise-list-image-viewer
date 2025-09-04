import Foundation
import SwiftUI

public struct TextBundle: View {
    @Environment(\.locale) private var locale
    @Environment(\.l10nOverrideBundles) private var overrideBundles
    
    private let resource: LocalizedStringResource
    
    public init(_ resource: LocalizedStringResource) {
        self.resource = resource
    }
    
    public var body: Text {
        TextBundleFactory(resource: resource, locale: locale, overrideBundles: overrideBundles)()        
    }
}

struct TextBundle_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        TextBundle(L10n.errorTitle)
            .bold()
            .kerning(1)
    }
}

