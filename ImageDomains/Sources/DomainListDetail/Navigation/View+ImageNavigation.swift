import SwiftUI
import ImageDS

extension View {
    func onImageNavigate(_ action: @escaping NavigateAction<ImageRoute>.Action) -> some View {
        self.environment(\.imageNavigate, NavigateAction(action: action))
    }
}
