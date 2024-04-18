import UIKit

final class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController?

    func initialViewController() -> UIViewController {
        let viewController = ListImagesFeature(
            router: .init(openImageDetailRoute: self.pushViewDetail(_:))
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        return navigationController
    }

    private func pushViewDetail(_ imageInfo: ImageInfoUI) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        navigationController?.pushViewController(viewController, animated: true)
    }
}
