import SwiftUI
import AppCore
import DesignSystem
import PixbayNetwork

struct ImagesListFeature: View {
    @StateObject var viewModel: AbstractViewModel<
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
    let viewModel = MockViewModel<
        ImagesListState, ImagesListIntent>(
        viewState: .mock
    )

    NavigationStack {
        ImagesListFeature(viewModel: viewModel)
    }
}
