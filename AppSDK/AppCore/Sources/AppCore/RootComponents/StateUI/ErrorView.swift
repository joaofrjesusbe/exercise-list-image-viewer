import SwiftUI

public struct ErrorView: View {
    @Environment(\.appEnvironment) private var env
    
    let errorState: ErrorState
    let retryAction: Action?
    
    public var body: some View {
        VStack(spacing: 8) {
            if let title = errorState.title {
                Text(title)
                    .foregroundColor(env.theme.textPrimary)
            }
            
            Text(errorState.description)
                .foregroundColor(env.theme.textPrimary)
            
            if let retry = retryAction {
                Button(
                    L10n.retry,
                    action: retry
                )
                .buttonStyle(.borderedProminent)
                .tint(env.theme.accent)
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
            title: "Ops",
            description: "My error description",
            icon: nil),
        retryAction: nil
    )
}
