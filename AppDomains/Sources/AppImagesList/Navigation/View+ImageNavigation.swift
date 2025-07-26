import SwiftUI
import AppCore

extension View {
    func onImageNavigate(_ action: @escaping NavigateAction<ImageRoute>.Action) -> some View {
        self.environment(\.imageNavigate, NavigateAction(action: action))
    }
}

struct ImageNavigationEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: NavigateAction = NavigateAction<ImageRoute>(action: { _ in })
}

extension EnvironmentValues {
    var imageNavigate: (NavigateAction<ImageRoute>) {
        get { self[ImageNavigationEnvironmentKey.self] }
        set { self[ImageNavigationEnvironmentKey.self] = newValue }
    }
}
