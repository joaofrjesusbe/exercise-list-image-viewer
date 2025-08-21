import SwiftUI

public extension View {
    @ViewBuilder
    func applyPreferredColorScheme(for mode: ThemeMode) -> some View {
        switch mode {
        case .light: self.preferredColorScheme(.light)
        case .dark:  self.preferredColorScheme(.dark)
        case .system: self // no override; let Environment(\.colorScheme) follow the OS
        }
    }
}

public extension View {
    /// Apply to any view that should keep theme synced with system while in `.system` mode.
    func syncSystemTheme() -> some View {
        modifier(SystemThemeSyncModifier())
    }
}


/// Keeps the app theme in sync with the system color scheme when `ThemeManager.mode == .system`.
private struct SystemThemeSyncModifier: ViewModifier {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var themer: ThemeManager

    private func syncToSystemIfNeeded() {
        guard themer.mode == .system else { return }
        themer.setColorScheme(systemScheme)
    }

    func body(content: Content) -> some View {
        content
            .onAppear {                                   // first launch
                syncToSystemIfNeeded()
            }
            .onChange(of: systemScheme) { _, _ in         // live OS toggle
                syncToSystemIfNeeded()
            }
            .onChange(of: scenePhase) { _, phase in       // app returns to foreground
                if phase == .active { syncToSystemIfNeeded() }
            }
            .onChange(of: themer.mode) { _, mode in       // user switches to “System”
                if mode == .system { syncToSystemIfNeeded() }
            }
    }
}
