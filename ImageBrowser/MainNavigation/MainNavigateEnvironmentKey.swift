import SwiftUI
import ImageCore

struct MainNavigationEnvironmentKey: EnvironmentKey {
    static var defaultValue: NavigateAction = NavigateAction<MainRoute>(action: { _ in })
}

extension EnvironmentValues {
    var mainNavigate: (NavigateAction<MainRoute>) {
        get { self[MainNavigationEnvironmentKey.self] }
        set { self[MainNavigationEnvironmentKey.self] = newValue }
    }
}
