import SwiftUI
import AppCore

public struct RootView<ViewState, Intent, Content: View>: View {
    @Environment(\.appEnvironment) private var env
    
    let viewModel: AbstractViewModel<ViewState, Intent>
    let loadIntent: Intent
    let content: (ViewState) -> Content
    
    public init(
        viewModel: AbstractViewModel<ViewState, Intent>,
        loadIntent: Intent,
        content: @escaping (ViewState) -> Content
    ) {
        self.viewModel = viewModel
        self.loadIntent = loadIntent
        self.content = content
    }
    
    public var body: some View {
        LoadableView(
            loadState: viewModel.state,
            retryAction: {
                viewModel.send(loadIntent)
            },
            content: { value in
                content(value)
                    .background(env.theme.background)
            }
        )
        .background(env.theme.background)
        .onAppear {
            if case .idle = viewModel.state {
                viewModel.send(loadIntent)
            }
        }
    }
}

#Preview {    
    let mock = MockViewModel<String, MockIntent>(viewState: "Hello world!")
    RootView(viewModel: mock, loadIntent: .loadData) { loaded in
        Text(loaded)
    }
}
