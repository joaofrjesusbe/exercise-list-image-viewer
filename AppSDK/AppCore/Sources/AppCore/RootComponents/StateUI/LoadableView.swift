import SwiftUI

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

            case .current(let viewState):
                content(viewState)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: String(describing: loadState))
    }
}

struct LoadableView_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        let loadState: LoadState<String> = .current("Hello world!")
        LoadableView(loadState: loadState, retryAction: nil) { viewState in
            Text(viewState)
        }
    }
}
