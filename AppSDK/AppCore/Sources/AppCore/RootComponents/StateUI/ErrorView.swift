import SwiftUI

public struct ErrorView: View {
    @EnvironmentObject private var themer: ThemeManager
    
    let errorState: ErrorState
    let retryAction: Action?
    
    public var body: some View {
        VStack(spacing: 8) {
            if let title = errorState.title {
                TextBundle(title)
                    .foregroundColor(themer.theme.textPrimary)
            }
            
            TextBundle(errorState.description)
                .foregroundColor(themer.theme.textPrimary)
            
            Spacer().frame(height: 8)
            
            if let retry = retryAction {
                Button(action: retry) {
                    Text(L10n.retry)
                }
                .buttonStyle(.borderedProminent)
                .tint(themer.theme.accent)
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}

struct ErrorView_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        ErrorView(
            errorState: ErrorState(
                title: L10n.errorTitle,
                description: L10n.errorNetworkGeneric,
                icon: nil),
            retryAction: { print("Retry!") }
        )
    }
}
