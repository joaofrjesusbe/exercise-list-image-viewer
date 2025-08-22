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
    
    @State var tabSelection: Int = 0
    
    var body: some Scene {
        WindowGroup {
            AppRootView(tabSelection: $tabSelection)
                .environment(\.appEnvironment, env)
                .environmentObject(env.themeManager)
                .environmentObject(env.languageManager)
                .environment(\.locale, env.languageManager.locale)
                .applyPreferredColorScheme(for: env.themeManager.mode)
        }
    }
}
