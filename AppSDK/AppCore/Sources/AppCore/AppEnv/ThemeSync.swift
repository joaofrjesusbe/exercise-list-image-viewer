import SwiftUI

struct ThemeSync: View {
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.appEnvironment) private var env

    var body: some View {
        EmptyView()
            .onAppear {
                env.updateTheme(for: systemColorScheme)
            }
            .onChange(of: systemColorScheme) { newColorScheme in
                env.updateTheme(for: newColorScheme)
            }
            .onChange(of: env.themeMode) { _ in
                env.updateTheme(for: systemColorScheme)
            }
    }
}

public extension View {
    func bindThemeSync() -> some View {
        self.background(ThemeSync())
    }
}
