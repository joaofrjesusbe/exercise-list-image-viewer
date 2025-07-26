import SwiftUI
import AppCore

public struct LoadingView: View {
    @Environment(\.appEnvironment) private var env
    
    public var body: some View {
        ProgressView(
            L10n.loading
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
 
#Preview {
    LoadingView()
}
