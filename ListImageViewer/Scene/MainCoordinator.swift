import SwiftUI

@Observable
class MainCoordinator {
    var viewPath = NavigationPath()

    @ObservationIgnored
    lazy var listImageFeature: ListImagesFeature = {
        return ListImagesFeature(
            router: .init(openDetailImage: { imageInfo in
                self.viewPath.append(imageInfo)
            })
        )
    }()
}
