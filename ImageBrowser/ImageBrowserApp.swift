import SwiftUI
import ImageIO
import DomainList

@main
struct ImageBrowserApp: App {
    @State var imageModel = ImageModel(
        query: "funny+dog",
        provider: ListImagesNetworkService(),
        minimumOffsetToLoadNextPage: 5
    )
    
    var body: some Scene {
        WindowGroup {
            ImageNavigationStack()
                .environmentObject(imageModel)
        }
    }
}
