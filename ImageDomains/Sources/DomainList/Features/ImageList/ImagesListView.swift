import SwiftUI
import ImageCore
import ImageDS

struct ImagesListView: View {
    @Environment(\.imageNavigate) private var navigate
    @EnvironmentObject var model: ImageModel
    let adapter: ImageListLoaderAdapter
    
    var body: some View {
        ScrollView {
            VStack {            
                LazyVStack {
                    ForEach(
                        Array(model.currentListing.items.enumerated()),
                        id: \.element)
                    { index, imageInfo in
                        DSListCell(
                            item: MapImageInfo.toCellItem(imageInfo),
                            didSelect: {
                                navigate(.push(.detail(imageInfo)))
                            }
                        )
                        .onAppear {
                            adapter.tryToLoadNextPage(index: index)
                        }
                    }
                }
                
                switch adapter.pageState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .failed(let error):
                    Button(action: adapter.loadNextPage) {
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
    let adapter = ImageListLoaderAdapter()
    let model = ImageModel.mock
    ImagesListView(adapter: adapter)
        .environmentObject(
            model
        )
        .onViewDidLoad {
            adapter.initialLoad(model: model)
        }
}
