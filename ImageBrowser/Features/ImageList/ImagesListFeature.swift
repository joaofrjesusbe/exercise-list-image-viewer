import SwiftUI
import ImageCore

struct ImagesListFeature: Feature {
    @EnvironmentObject var model: ImageModel
    
    @State var state: ViewState<Void, String> = .idle
        
    var body: some View {
        ZStack(alignment: .center) {
            stateView
        }
        .task {
            await initialLoad()
        }
        .background(.white)
        .navigationTitle(model.query)
    }

    @ViewBuilder
    var stateView: some View {
        switch state {
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
    
    func initialLoad() async {
        state = .loading
        do {
            try await model.initialLoad()
            state = .didLoad(())
        } catch let error as NetworkError {
            state = .failed(error.debugDescription)
        } catch {
            state = .failed("Unknown error")
        }
    }
}

#Preview {
    NavigationStack {
        ImagesListFeature()
            .environmentObject(
                ImageModel.mock
            )
    }
}
