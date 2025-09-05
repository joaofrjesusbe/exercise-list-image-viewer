import SwiftUI
import AppGroup

struct ImagesListRootView: View {
    @StateObject var viewModel: LoadViewModel<
        ImagesListState, ImagesListIntent>
    
    var body: some View {
        RootView(
            viewModel: viewModel,
            loadIntent: .initialSearch
        ) { viewState in
            ImagesListView(onIntent: viewModel, state: viewState)
        }
    }
}
