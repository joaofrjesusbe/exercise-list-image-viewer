import SwiftUI
import AppCore
import DesignSystem
import PixbayNetwork

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

#Preview {
    /*
    let viewModel = MockViewModel<
        ImagesListState, ImagesListIntent>(
        viewState: .mock
    )
    */
    
    let viewModel = ImagesListDI.createImageListViewModel()

    NavigationStack {
        ImagesListRootView(viewModel: viewModel)
    }
}
