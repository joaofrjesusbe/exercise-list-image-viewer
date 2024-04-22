import UIKit
import SwiftUI

final class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController?

    func initialViewController() -> UIViewController {
        let viewController = ListImagesFeature(
            .init(openDetailImage: self.pushViewDetail(_:))
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        return navigationController
    }

    private func pushViewDetail(_ imageInfo: ImageInfoUI) {
        let rootView = ImageDetailRootView(imageInfo: imageInfo)
        let viewController = UIHostingController(rootView: rootView)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
