import SwiftUI

public struct DarkTheme: Themeable {
    public init() {}
    
    public let background: Color = .black
    #if os(iOS)
    public let backgroundSecondary: Color = Color(.secondarySystemBackground)
    #else
    public let backgroundSecondary: Color = Color.gray.opacity(0.2)
    #endif
    public let textPrimary: Color = .white
    #if os(iOS)
    public let textSecondary: Color = Color(.lightGray)
    #else
    public let textSecondary: Color = Color.gray
    #endif
    public let accent: Color = .teal
}
