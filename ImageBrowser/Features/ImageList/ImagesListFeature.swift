import SwiftUI

struct ImagesListFeature: Feature {
    @EnvironmentObject var viewModel: ImageListViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            stateView
        }
        .onAppear {
            viewModel.initialLoad()
        }
        .background(.white)
        .navigationTitle(viewModel.query)
    }

    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .failed:
            Text("Ups something went wrong")
        case .didLoad:
            ImagesListView()                
        }
    }
}

#Preview {
    NavigationStack {
        ImagesListFeature()
            .environmentObject(
                ImageListViewModel(model: ImageModel.mock)
            )
    }
}
