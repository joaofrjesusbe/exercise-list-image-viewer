import Foundation

enum L10n {
    
    public static let settignsTitle = LocalizedStringResource(
        "settings.title",
        defaultValue: "Settings",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Tabbar and NavigationBar settings title"
    )
    
    public static let settingsAppearance = LocalizedStringResource(
        "settings.appearance",
        defaultValue: "Dark Mode",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Settings appearance title"
    )
    
    public static let settingsLanguage = LocalizedStringResource(
        "settings.language",
        defaultValue: "Language",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Settings language title"
    )
    
    public static let themeLight = LocalizedStringResource(
        "settings.theme.light",
        defaultValue: "Light",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Setting label light theme"
    )
    
    public static let themeDark = LocalizedStringResource(
        "settings.theme.dark",
        defaultValue: "Dark",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Setting label dark theme"
    )
    
    public static let themeSystem = LocalizedStringResource(
        "settings.theme.system",
        defaultValue: "System",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Setting label system theme"
    )
}
