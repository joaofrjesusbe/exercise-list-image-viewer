import SwiftUI

@MainActor
public struct Theme {
    public let background: Color
    public let backgroundSecondary: Color
    public let textPrimary: Color
    public let textSecondary: Color
    public let accent: Color

    public static let light = Theme(
        background: Color.white,
        backgroundSecondary: Color(.systemGray6),
        textPrimary: Color.black,
        textSecondary: Color.gray,
        accent: Color.blue
    )
    
    public static let dark = Theme(
        background: Color.black,
        backgroundSecondary: Color(.secondarySystemBackground),
        textPrimary: Color.white,
        textSecondary: Color(.lightGray),
        accent: Color.teal
    )
}

private struct ThemeKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: Theme = .light
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
