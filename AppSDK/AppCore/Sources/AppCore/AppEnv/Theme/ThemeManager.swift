import SwiftUI

@MainActor
public final class ThemeManager: ObservableObject {
    /// User preference: .system, .light, .dark
    @Published public var mode: ThemeMode {
        didSet { resolveTheme() }
    }

    /// Concrete theme tokens your UI should read from
    @Published public private(set) var theme: any Themeable

    /// Current system scheme; affects `.system` mode only
    public private(set) var systemScheme: ColorScheme

    /// Brand themes
    private let lightTheme: any Themeable
    private let darkTheme: any Themeable
    
    private let log: Logger

    public init(
        log: Logger,
        mode: ThemeMode = .system,
        systemScheme: ColorScheme = .light,
        lightTheme: any Themeable = LightTheme(),
        darkTheme: any Themeable = DarkTheme(),
    ) {
        self.log = log
        self.mode = mode
        self.systemScheme = systemScheme
        self.lightTheme = lightTheme
        self.darkTheme = darkTheme
        self.theme = lightTheme  // temporary; will be resolved next
        resolveTheme()
    }

    /// Update from @Environment(\.colorScheme)
    public func setColorScheme(_ scheme: ColorScheme) {
        guard scheme != systemScheme else { return }
        systemScheme = scheme
        if mode == .system {
            resolveTheme()
            objectWillChange.send()
        }
    }

    /// Handy for `.preferredColorScheme(...)`
    public var preferredColorScheme: ColorScheme? {
        switch mode {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    // MARK: - Private

    private func resolveTheme() {
        switch mode {
        case .light:
            theme = lightTheme
        case .dark:
            theme = darkTheme
        case .system:
            theme = (systemScheme == .dark) ? darkTheme : lightTheme
        }
        
        log.warning("Resolve theme to \(String(describing: theme))")
    }
}
