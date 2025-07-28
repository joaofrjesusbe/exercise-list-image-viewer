import SwiftUI
import AppCore
import DesignSystem
import PixbayNetwork
import FactoryKit

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
    Container.shared.imagePageService.preview { MockImagePageService() }
    let viewModel = ImagesListDI.createImageListViewModel()

    NavigationStack {
        ImagesListRootView(viewModel: viewModel)
    }
}
