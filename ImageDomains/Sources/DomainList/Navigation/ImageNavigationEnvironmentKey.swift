import SwiftUI
import ImageDS

struct ImageNavigationEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: NavigateAction = NavigateAction<ImageRoute>(action: { _ in })
}

extension EnvironmentValues {
    var imageNavigate: (NavigateAction<ImageRoute>) {
        get { self[ImageNavigationEnvironmentKey.self] }
        set { self[ImageNavigationEnvironmentKey.self] = newValue }
    }
}
