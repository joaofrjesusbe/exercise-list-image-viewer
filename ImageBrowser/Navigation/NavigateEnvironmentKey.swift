import SwiftUI
import ImageCore

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue: NavigateAction = NavigateAction<Route>(action: { _ in })
}

extension EnvironmentValues {
    var navigate: (NavigateAction<Route>) {
        get { self[NavigateEnvironmentKey.self] }
        set { self[NavigateEnvironmentKey.self] = newValue }
    }
}
