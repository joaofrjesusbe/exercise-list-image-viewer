import SwiftUI

public struct LoadingView: View {
    
    public var body: some View {
        ProgressView(L10n.loading)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
 
struct LoadingView_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        LoadingView()
    }
}
