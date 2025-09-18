import SwiftUI
import Testing
import ViewInspector
@testable import AppCore

@MainActor
struct LoadableViewTests {
    
    @Test
    func idleState_showsLoadingView() throws {
        let sut = themed(
            LoadableView(loadState: LoadState<String>.idle, retryAction: nil) { value in
                Text(value)
            }
        )

        // Expect to find a LoadingView in the hierarchy
        _ = try sut.inspect().find(LoadingView.self)
    }

    @Test
    func loadingState_showsLoadingView() throws {
        let sut = themed(
            LoadableView(loadState: LoadState<String>.loading, retryAction: nil) { value in
                Text(value)
            }
        )

        _ = try sut.inspect().find(LoadingView.self)
    }

    @Test
    func failedState_showsErrorView_withRetryButton() throws {
        var retryCount = 0
        let error = ErrorState(title: L10n.errorTitle, description: L10n.errorNetworkGeneric)

        let sut = themed(
            LoadableView(loadState: LoadState<String>.failed(error), retryAction: { retryCount += 1 }) { value in
                Text(value)
            }
        )

        // ErrorView is present
        _ = try sut.inspect().find(ErrorView.self)

        // Find the Button inside ErrorView and verify label, then tap
        let button = try sut.inspect().find(ViewType.Button.self)
        #expect(try button.labelView().text().string() == "Retry")

        try button.tap()
        #expect(retryCount == 1)
    }

    @Test
    func currentState_rendersProvidedContent() throws {
        let contentText = "Hello world!"
        let sut = themed(
            LoadableView(loadState: LoadState<String>.current(contentText), retryAction: nil) { value in
                Text(value)
            }
        )

        // Verify the content closure's Text is rendered
        let text = try sut.inspect().find(text: contentText)
        #expect(try text.string() == contentText)
    }
}

