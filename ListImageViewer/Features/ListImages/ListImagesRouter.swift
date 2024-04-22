import Foundation

struct ListImagesRouter {
    var openDetailImage: (ImageInfoUI) -> Void

    init(openDetailImage: @escaping (ImageInfoUI) -> Void) {
        self.openDetailImage = openDetailImage
    }
}
