import AppCore
import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject private var themer: ThemeManager
    @EnvironmentObject private var langManager: LanguageManager
    
    public init() {}
    
    public var body: some View {
        Form {
            Section(L10n.settingsAppearanceTitle) {
                Picker(L10n.settingsAppearanceTitle, selection: Binding(
                    get: { themer.mode },
                    set: { themer.mode = $0 }
                )) {
                    ForEach(ThemeMode.allCases, id: \.rawValue) { mode in
                        Text(mode == .system ? "System" : mode == .light ? "Light" : "Dark")
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
            /*
            Section(L10n.settingsLanguageTitle) {
                Picker(L10n.settingsLanguageTitle, selection: Binding(
                    get: { langManager.currentLanguage },
                    set: { langManager.select(code: $0) }
                )) {
                    ForEach(langManager.supportedLanguages, id: \.self) { code in
                        Text(langManager.displayName(for: code))
                            .tag(code)
                    }
                }
            }
             */
        }
        .background(themer.theme.background)
        .navigationTitle(L10n.settignsTitle)
    }
}


extension SettingsView: NavigationRepresentable {
    
    public var navigationItem: NavigationItem {
        NavigationItem(icon: SystemImages.tabBarIconSettings, text: L10n.settignsTitle)
    }
}
