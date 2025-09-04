import SwiftUI

public struct RootView<ViewState, Intent, Content: View>: View {
    @Environment(\.locale) private var locale
    @EnvironmentObject private var themer: ThemeManager
    
    let viewModel: LoadViewModel<ViewState, Intent>
    let loadIntent: Intent
    let content: (ViewState) -> Content
    
    public init(
        viewModel: LoadViewModel<ViewState, Intent>,
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
                    .background(themer.theme.background)
            }
        )
        .background(themer.theme.background)
        .onAppear {
            viewModel.updateLocale(locale)
            if case .idle = viewModel.state {
                viewModel.send(loadIntent)
            }
        }
        .onChange(of: locale) {  _, newValue in
            viewModel.updateLocale(newValue)
        }
    }
}

struct RootView_Previews: DefaultPreviewProvider, PreviewProvider {
    static func content(for localeID: String) -> some View {
        let mock = MockViewModel<String, MockIntent>(error: MockError())
        RootView(viewModel: mock, loadIntent: .loadData) { loaded in
            Text(loaded)
        }
    }
} 
