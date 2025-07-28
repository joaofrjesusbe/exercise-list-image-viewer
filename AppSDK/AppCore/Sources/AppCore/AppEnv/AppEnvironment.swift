import SwiftUI

@MainActor
public final class AppEnvironment: ObservableObject {
    
    public enum ThemeMode: String, CaseIterable {
        case system
        case light
        case dark
    }
    
    @Published public var themeMode: ThemeMode = .system
    @Published public var theme: Theme
    @Published public var languageManager: LanguageManager
    
    public init(theme: Theme = .light, supportedLanguages: [String] = ["en"]) {
        self.theme = theme
        self.languageManager = LanguageManager(supportedLanguages: supportedLanguages)
    }
    
    /// Call this on appearance changes or View injection
    public func updateTheme(for systemColorScheme: ColorScheme) {
        switch themeMode {
        case .system:
            self.theme = systemColorScheme == .dark ? .dark : .light
        case .light:
            self.theme = .light
        case .dark:
            self.theme = .dark
        }
    }
}

public struct AppEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor
    public static let defaultValue = AppEnvironment()
}

public extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
