import SwiftUI

public enum ThemeMode: String, CaseIterable, Identifiable, Sendable {
    public var id: String { rawValue }
    case system
    case light
    case dark
}
