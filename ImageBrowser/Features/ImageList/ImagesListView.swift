import SwiftUI
import ImageCore
import ImageDS

struct ImagesListView: View {
    @EnvironmentObject var viewModel: ImageListViewModel
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        ScrollView {
            VStack {            
                LazyVStack {
                    ForEach(
                        Array(viewModel.items.enumerated()),
                        id: \.element)
                    { index, item in
                        DSListCell(
                            item: item,
                            didSelect: {
                                let imageInfo = viewModel.modelForIndex(index)
                                navigate(.push(.detail(imageInfo)))
                            }
                        )
                        .onAppear {
                            viewModel.tryToLoadNextPage(index: index)
                        }
                    }
                }
                
                switch viewModel.pageState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .failed(let error):
                    Button(action: viewModel.loadNextPage) {
                        VStack(alignment: .center) {
                            Text(error)
                            Text("Tap to retry")
                        }
                    }
                }
            }
            .background(.white)
        }
    }    
}

#Preview {
    ImagesListView()
        .environmentObject(
            ImageListViewModel(model: ImageModel.mock)
        )
}
