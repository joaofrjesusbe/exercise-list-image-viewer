import SwiftUI
import AppCore
import DesignSystem
import PixbayNetwork
import FactoryKit

struct ImagesListView: View {
    @EnvironmentObject private var themer: ThemeManager
    @Environment(\.imageNavigate) private var navigate
    
    let onIntent: IntentSendable<ImagesListIntent>
    let state: ImagesListState
    
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                listItems
                pageState
            }
            .background(themer.theme.background)
            .navigationTitle(state.query)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .focused($isSearchFocused)
        .onChange(of: searchText) { _, newValue in
            onIntent.send(.updateSearchText(newValue))
        }
        .onSubmit(of: .search) {
            onIntent.send(.submitSearch)
            searchText = ""
            isSearchFocused = false
        }
        .onAppear { searchText = state.query }
        .onChange(of: state.query) {_, newValue in searchText = newValue }
        .background(themer.theme.background)
    }
    
    var listItems: some View {
        LazyVStack {
            ForEach(0..<state.listingItems.count, id: \.self) { index in
                let item = state.listingItems[index]
                DSListCell(
                    item: item,
                    didSelect: {
                        navigate(.push(.detail(index)))
                    }
                )
                .onAppear {
                    onIntent.send(.newItemAppeared(index))
                }
            }
        }
    }
    
    @ViewBuilder
    var pageState: some View {
        switch state.listingState {
        case .idle, .current:
            EmptyView()
        case .loading:
            ProgressView()
        case .failed(let error):
            Button(action: {
                onIntent.send(.reloadNextPage)
            }) {
                VStack(alignment: .center) {
                    LocalizedText(error.description)
                    AppCore.AppCoreL10n.retry.asTextView
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImagesListView(onIntent: MockIntentSendable(), state: .mock)
            .previewWithTheme()
    }
}
