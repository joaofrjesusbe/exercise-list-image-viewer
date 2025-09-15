import SwiftUI

public struct LightTheme: Themeable {
    public init() {}
    
    public let background: Color = .white
    #if os(iOS)
    public let backgroundSecondary: Color = Color(.systemGray6)
    #else
    public let backgroundSecondary: Color = Color.gray.opacity(0.1)
    #endif
    public let textPrimary: Color = .black
    public let textSecondary: Color = .gray
    public let accent: Color = .blue
}
