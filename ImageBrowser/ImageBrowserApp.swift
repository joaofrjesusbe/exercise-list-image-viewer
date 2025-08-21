import SwiftUI
import AppImagesList
import AppCore
import AppMain

@main
struct ImageBrowserApp: App {
    @StateObject private var env = AppEnvironment(
        config: AppConfig(
            supportedLanguages: ["en", "pt"],
            themeModes: [.system, .light, .dark]
        )
    )
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .applyPreferredColorScheme(for: env.themeManager.mode)
                .environment(\.appEnvironment, env)
                .environmentObject(env.themeManager)
                .environmentObject(env.languageManager)
                .environment(\.locale, env.languageManager.locale)
        }
    }
}
