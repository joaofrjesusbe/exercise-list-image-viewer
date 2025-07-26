import SwiftUI

@MainActor
public final class AppEnvironment: ObservableObject {
    @Published public var theme: Theme
    @Published public var language: LanguageManager = LanguageManager()
    
    public init(theme: Theme = .light) {
        self.theme = theme
    }
}

public struct AppEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor
    public static let defaultValue = AppEnvironment()
}

public extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
