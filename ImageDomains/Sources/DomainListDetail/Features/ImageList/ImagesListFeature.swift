import SwiftUI
import ImageCore
import ImageDS

struct ImagesListFeature: Feature {
    @EnvironmentObject var model: ImageModel
    @State var adapter = ImageListLoaderAdapter()
    
    var body: some View {
        ZStack(alignment: .center) {
            stateView
        }
        .onViewDidLoad {
            Task {
                await adapter.initialLoad(model: model)
            }
        }
        .background(.white)
        .navigationTitle(model.query)
    }

    @ViewBuilder
    var stateView: some View {
        switch adapter.state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .failed:
            Text("Ups something went wrong")
        case .didLoad:
            ImagesListView(adapter: adapter)
        }
    }
}

#Preview {    
    ImagesListFeature()
        .environmentObject(
            ImageModel.mock
        )
}
