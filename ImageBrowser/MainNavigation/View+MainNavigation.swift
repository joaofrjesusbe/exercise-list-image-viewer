import SwiftUI
import ImageCore

extension View {
    func onMainNavigate(_ action: @escaping NavigateAction<MainRoute>.Action) -> some View {
        self.environment(\.mainNavigate, NavigateAction(action: action))
    }
}
