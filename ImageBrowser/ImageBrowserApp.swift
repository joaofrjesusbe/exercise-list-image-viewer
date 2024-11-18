import SwiftUI

@main
struct ImageBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            MainNavigationStack {
                ImagesListFeature()
            }
            .environmentObject(
                ImageListViewModel(model:
                    ImageModel(
                        query: "funny+dog",
                        provider: ListImagesNetworkService(),
                        minimumOffsetToLoadNextPage: 5
                    )
                )
            )
        }
    }
}
