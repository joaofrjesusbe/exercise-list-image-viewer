import SwiftUI

public struct DarkTheme: Themeable {
    public init() {}
    
    public let background: Color = .black
    public let backgroundSecondary: Color = Color(.secondarySystemBackground)
    public let textPrimary: Color = .white
    public let textSecondary: Color = Color(.lightGray)
    public let accent: Color = .teal
}
