import AppCore

@MainActor
enum L10n {
    static let settignsTitle = LocalizedKey("settings.title")
    static let settingsAppearance = LocalizedKey("settings.appearance")
    static let settingsLanguage = LocalizedKey("settings.language")
    
    static let themeLight = LocalizedKey("settings.theme.light")
    static let themeDark = LocalizedKey("settings.theme.dark")
    static let themeSystem = LocalizedKey("settings.theme.system")
}
