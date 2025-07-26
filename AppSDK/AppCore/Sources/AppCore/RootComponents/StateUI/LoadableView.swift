import SwiftUI
import AppCore

public struct LoadableView<ViewState, Content: View>: View {
    let loadState: LoadState<ViewState>
    let retryAction: Action?
    let content: (_ viewState: ViewState) -> Content

    public var body: some View {
        Group {
            switch loadState {
            case .idle, .loading:
                LoadingView()

            case .failed(let errorState):
                ErrorView(errorState: errorState, retryAction: retryAction)

            case .didLoad(let viewState):
                content(viewState)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: String(describing: loadState))
    }
}

#Preview {
    let loadState: LoadState<String> = .didLoad("Hello world!")
    
    LoadableView(loadState: loadState, retryAction: nil) { viewState in
        Text(viewState)
    }
}
