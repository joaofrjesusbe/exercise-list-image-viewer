import SwiftUI
import AppCore
import DesignSystem
import PixbayNetwork
import FactoryKit

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

#Preview {
    Container.shared.imagePageService.preview { MockImagePageService() }
    let viewModel = ImagesListDI.createImageListViewModel()

    NavigationStack {
        ImagesListRootView(viewModel: viewModel)
    }
}
