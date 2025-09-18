import SwiftUI
import Testing
import ViewInspector
@testable import AppCore

@MainActor
struct RootViewTests {

    @Test
    func failedState_retryButton_sendsLoadIntent() throws {
        var sendCount = 0
        var didSendLoadData = false
        let error = ErrorState(title: L10n.errorTitle, description: L10n.errorNetworkGeneric)

        let vm = MockViewModel<String, MockIntent>(loadState: .failed(error), onIntent: { intent, _ in
            sendCount += 1
            if case .loadData = intent { didSendLoadData = true }
        })

        let sut = themed(
            RootView(viewModel: vm, loadIntent: .loadData) { state in
                Text(state)
            }
        )

        // Find the Retry button and tap it
        let button = try sut.inspect().find(ViewType.Button.self)
        #expect(try button.labelView().text().string() == "Retry")
        try button.tap()

        #expect(sendCount == 1)
        #expect(didSendLoadData)
    }

    @Test
    func onAppear_sendsLoadIntent_onlyOnFirstWhenStateChangesAfterFirst() async throws {
        var sendCount = 0
        let vm = MockViewModel<String, MockIntent>(loadState: .idle, onIntent: { intent, _ in
            if case .loadData = intent { sendCount += 1 }
        })

        let view = themed(
            RootView(viewModel: vm, loadIntent: .loadData) { state in
                Text(state)
            }
        )

        // First appear
        ViewInspector.ViewHosting.host(view: view)
        defer { ViewInspector.ViewHosting.expel() }
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
        #expect(sendCount == 1)

        // Change state so subsequent appears should not trigger load
        vm.update(.loading)

        // Disappear and appear again
        ViewInspector.ViewHosting.expel()
        try await Task.sleep(nanoseconds: 10_000_000)
        ViewInspector.ViewHosting.host(view: view)
        try await Task.sleep(nanoseconds: 50_000_000)

        #expect(sendCount == 1)
    }

    @Test
    func rendersProvidedContent_whenInCurrentState() throws {
        let contentText = "Hello"
        let vm = MockViewModel<String, MockIntent>(loadState: .current(contentText))

        let sut = themed(
            RootView(viewModel: vm, loadIntent: .loadData) { state in
                Text(state)
            }
        )

        let text = try sut.inspect().find(text: contentText)
        #expect(try text.string() == contentText)
    }
}
