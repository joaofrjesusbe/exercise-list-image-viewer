import SwiftUI
import AppGroup

struct ImagesListRootView: View {
    @StateObject var viewModel: LoadViewModel<
        ImagesListState, ImagesListIntent>
    
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        RootView(
            viewModel: viewModel,
            loadIntent: .initialSearch
        ) { viewState in
            ImagesListView(onIntent: viewModel, state: viewState)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .focused($isSearchFocused)
        .onSubmit(of: .search) {
            viewModel.send(.submitSearch)
            searchText = ""
            isSearchFocused = false
        }
        .onAppear {
            searchText = viewModel.state.viewState?.query ?? ""
        }
        .onChange(of: viewModel.state) {_, newValue in
            searchText = viewModel.state.viewState?.query ?? ""
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.send(.updateSearchText(newValue))
        }
    }
}
