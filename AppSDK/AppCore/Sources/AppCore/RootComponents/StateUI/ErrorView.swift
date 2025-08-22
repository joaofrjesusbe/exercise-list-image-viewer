import SwiftUI

public struct ErrorView: View {
    @EnvironmentObject private var themer: ThemeManager
    
    let errorState: ErrorState
    let retryAction: Action?
    
    public var body: some View {
        VStack(spacing: 8) {
            if let title = errorState.title {
                LocalizedText(title)
                    .foregroundColor(themer.theme.textPrimary)
            }
            
            LocalizedText(errorState.description)
                .foregroundColor(themer.theme.textPrimary)
            
            if let retry = retryAction {
                Button(
                    L10n.retry.asLocalizedKey,
                    action: retry
                )
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

#Preview {
    ErrorView(
        errorState: ErrorState(
            title: .plain("Ops"),
            description: .plain("My error description"),
            icon: nil),
        retryAction: nil
    )
}
