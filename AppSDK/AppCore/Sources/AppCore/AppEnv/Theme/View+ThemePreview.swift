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
