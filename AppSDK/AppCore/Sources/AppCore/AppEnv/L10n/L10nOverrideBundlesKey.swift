import SwiftUI

private struct L10nOverrideBundlesKey: EnvironmentKey {
    static let defaultValue: [Bundle] = [.main]   // default white-label: app catalog only
}

public extension EnvironmentValues {
    var l10nOverrideBundles: [Bundle] {
        get { self[L10nOverrideBundlesKey.self] }
        set { self[L10nOverrideBundlesKey.self] = newValue }
    }
}

public extension View {
    /// Set once at the app/root view. If you don’t call this, `.main` is used.
    func localizationOverrides(_ bundles: [Bundle]) -> some View {
        environment(\.l10nOverrideBundles, bundles)
    }
}
