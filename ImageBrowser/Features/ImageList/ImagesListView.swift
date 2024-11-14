import SwiftUI
import ImageCore
import ImageDS

struct ImagesListView: View {
    @EnvironmentObject var model: ImageModel
    @Environment(\.navigate) private var navigate
    
    @State var pageState: ListingPaginationState<String> = .idle
    
    var body: some View {
        ScrollView {
            VStack {            
                LazyVStack {
                    ForEach(
                        Array(model.currentListing.items.enumerated()),
                        id: \.element)
                    { index, imageInfo in
                        DSListCell(
                            input: MapImageInfo.toCell(imageInfo),
                            didSelect: {
                                navigate(.push(.detail(imageInfo)))
                            }
                        )
                        .onAppear {
                            tryToLoadNextPage(index: index)
                        }
                    }
                }
                
                switch pageState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .failed(let error):
                    Button(action: loadNextPage) {
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
    
    func tryToLoadNextPage(index: Int) {
        if model.shouldLoadNextPage(index: index) {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        Task { @MainActor in
            pageState = .loading
            do {
                try await model.loadNextPage()
                pageState = .idle
            } catch let error as NetworkError {
                pageState = .failed(error.debugDescription)
            } catch {
                pageState = .failed("Unknown error")
            }
        }
    }
}

#Preview {
    ImagesListView(pageState: .idle)
        .environmentObject(
            ImageModel.mockPageLoaded
        )
}
