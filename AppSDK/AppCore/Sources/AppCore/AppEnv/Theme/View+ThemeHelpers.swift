import SwiftUI

// MARK: - Preview Helper
public extension View {
    /// Injects a default `ThemeManager` for SwiftUI previews
    func previewWithTheme(
        mode: ThemeMode = .system,
        systemScheme: ColorScheme = .light
    ) -> some View {
        let themeManager = ThemeManager(
            log: ConsoleLogger(),
            mode: mode,
            systemScheme: systemScheme
        )
        
        return self
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.preferredColorScheme ?? systemScheme)
    }
}

@MainActor
public func themed<V: View>(_ view: V, locale: Locale = Locale(identifier: "en_US")) -> some View {
    view
        .environmentObject(ThemeManager(log: ConsoleLogger()))
        .environment(\.locale, locale)
}
