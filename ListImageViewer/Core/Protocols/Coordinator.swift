import UIKit

protocol Coordinator {

    @MainActor
    func initialViewController() -> UIViewController
}
