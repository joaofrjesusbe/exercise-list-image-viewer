import SwiftUI
import AppCore
import DesignSystem
import PixbayNetwork
import FactoryKit

struct ImagesListView: View {
    @Environment(\.appEnvironment) private var env
    @Environment(\.imageNavigate) private var navigate
    @Injected(\.imageInfoUIAdapter) private var adapter
    
    let onIntent: IntentSendable<ImagesListIntent>
    let state: ImagesListState
    
    var body: some View {
        ScrollView {
            VStack {
                listItems
                pageState
            }
            .background(env.theme.background)
            .navigationTitle(state.query)
        }
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
        case .idle, .didLoad:
            EmptyView()
        case .loading:
            ProgressView()
        case .failed(let error):
            Button(action: {
                onIntent.send(.reloadNextPage)
            }) {
                VStack(alignment: .center) {
                    Text(error.description)
                    Text(AppCore.L10n.retry)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImagesListView(onIntent: MockIntentSendable(), state: .mock)
    }
}
