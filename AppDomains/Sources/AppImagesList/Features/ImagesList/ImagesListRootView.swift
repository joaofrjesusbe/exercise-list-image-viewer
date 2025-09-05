import SwiftUI
import AppGroup

struct ImagesListRootView: View {
    @EnvironmentObject private var themer: ThemeManager
    @StateObject var viewModel: LoadViewModel<
        ImagesListState, ImagesListIntent>
    
    var body: some View {
        RootView(
            viewModel: viewModel,
            loadIntent: .initialSearch
        ) { viewState in
            ImagesListView(onIntent: viewModel, state: viewState)
        }
        .background(themer.theme.background)
    }
}
