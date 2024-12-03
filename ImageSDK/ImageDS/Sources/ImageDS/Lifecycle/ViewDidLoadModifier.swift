import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var hasAppeared = false

    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    action()
                }
            }
    }
}

public extension View {
    func onViewDidLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}
