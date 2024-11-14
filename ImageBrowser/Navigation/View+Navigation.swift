import SwiftUI
import ImageCore

extension View {
    func onNavigate(_ action: @escaping NavigateAction<Route>.Action) -> some View {
        self.environment(\.navigate, NavigateAction(action: action))
    }
}
