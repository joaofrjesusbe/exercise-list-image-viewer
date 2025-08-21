import SwiftUI

public struct AppEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor
    public static let defaultValue = AppEnvironment(config: .default)
}

public extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
