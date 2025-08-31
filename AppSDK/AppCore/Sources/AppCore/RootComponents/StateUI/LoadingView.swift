import SwiftUI

public struct LoadingView: View {
    @EnvironmentObject private var themer: ThemeManager
    
    public var body: some View {
        ProgressView(
            L10n.loading.asLocalizedKey
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
 
#Preview {
    LoadingView()
        .previewWithTheme()
}
