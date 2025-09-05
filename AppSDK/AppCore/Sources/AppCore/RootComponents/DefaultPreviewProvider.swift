import SwiftUI

public protocol DefaultPreviewProvider: PreviewProvider {
    associatedtype Content: View
    
    static var locales: [String] { get }
    
    @ViewBuilder static func content(for localeID: String) -> Content
}

public extension DefaultPreviewProvider {
    
    static var locales: [String] {
        LanguageCode.allCases.map(\.rawValue)
    }
    
    static var previews: some View {
        ForEach(locales, id: \.self) { id in
            content(for: id)
                .environment(\.locale, Locale(identifier: id))
                .previewDisplayName(id)
                .previewWithTheme()
        }
    }
}
