import SwiftUI

public struct LightTheme: Themeable {
    public init() {}
    
    public let background: Color = .white
    public let backgroundSecondary: Color = Color(.systemGray6)
    public let textPrimary: Color = .black
    public let textSecondary: Color = .gray
    public let accent: Color = .blue
}
