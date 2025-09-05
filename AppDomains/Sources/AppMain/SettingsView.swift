import SwiftUI
import AppGroup

public struct SettingsView: View {
    @EnvironmentObject private var themer: ThemeManager
    @EnvironmentObject private var langManager: LanguageManager

    public init() {}

    public var body: some View {
        Form {
            SettingsAppearanceSection()
            SettingsLanguageSection()
        }
        .background(themer.theme.background)
        .navigationTitle(L10n.settignsTitle)
    }
}

// MARK: - Appearance

private struct SettingsAppearanceSection: View {
    @EnvironmentObject private var themer: ThemeManager

    var body: some View {
        Section(L10n.settingsAppearance) {
            Picker(L10n.settingsAppearance,
                   selection: Binding(
                        get: { themer.mode },
                        set: { themer.mode = $0 }
                   )) {
                ForEach(ThemeMode.allCases, id: \.rawValue) { mode in
                    Text(label(for: mode))
                        .tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func label(for mode: ThemeMode) -> LocalizedStringResource {
        switch mode {
        case .system: return L10n.themeSystem
        case .light:  return L10n.themeLight
        case .dark:   return L10n.themeDark
        }
    }
}

// MARK: - Language

private struct SettingsLanguageSection: View {
    @EnvironmentObject private var langManager: LanguageManager

    var body: some View {
        Section(L10n.settingsLanguage) {
            Picker(L10n.settingsLanguage,
                   selection: Binding(
                        get: { langManager.currentLanguage },
                        set: { langManager.select(language: $0) }
                   )) {
                ForEach(langManager.supportedLanguages, id: \.self) { code in
                    Text(langManager.displayName(for: code))
                        .tag(code)
                }
            }
        }
    }
}

// MARK: - Navigation

extension SettingsView: NavigationRepresentable {
    public var navigationItem: NavigationItem {
        // If NavigationItem.text expects a LocalizedStringKey, use `.asLocalizedKey`
        NavigationItem(icon: SystemImages.tabBarIconSettings, text: L10n.settignsTitle)
    }
}
