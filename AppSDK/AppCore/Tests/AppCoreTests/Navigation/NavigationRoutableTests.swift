@testable import AppCore
import Testing

// MARK: - Test Route
private enum TestRoute: Routable {
    case a, b, c, d

    var debugDescription: String {
        switch self {
        case .a: return "A"
        case .b: return "B"
        case .c: return "C"
        case .d: return "D"
        }
    }
}

// MARK: - Harness implementing NavigationRoutable
@MainActor
private struct DummyNav: NavigationRoutable {
    typealias Route = TestRoute
    var routes: [TestRoute] = []

    func handleNavigation(_ navType: NavigationType<TestRoute>) {
        // no-op (not used directly in tests)
    }

    // Helper to expose the default implementation for testing
    func apply(_ nav: NavigationType<TestRoute>, to stack: inout [TestRoute]) {
        handleNavigationStack(stack: &stack, navType: nav)
    }
}

// MARK: - Tests
@MainActor
final class NavigationRoutableTests: @unchecked Sendable {
    private let nav = DummyNav()

    @Test
    func push_appends_route() {
        var stack: [TestRoute] = []
        nav.apply(.push(.a), to: &stack)
        #expect(stack == [.a])
        nav.apply(.push(.b), to: &stack)
        #expect(stack == [.a, .b])
    }

    @Test
    func back_pops_last_when_not_empty() {
        var stack: [TestRoute] = [.a, .b]
        nav.apply(.back, to: &stack)
        #expect(stack == [.a])
        nav.apply(.back, to: &stack)
        #expect(stack.isEmpty)
    }

    @Test
    func back_on_empty_is_noop() {
        var stack: [TestRoute] = []
        nav.apply(.back, to: &stack)
        #expect(stack.isEmpty)
    }

    @Test
    func home_clears_stack() {
        var stack: [TestRoute] = [.a, .b, .c]
        nav.apply(.home, to: &stack)
        #expect(stack.isEmpty)
    }

    @Test
    func forwardAndReplace_replaces_last_when_present() {
        var stack: [TestRoute] = [.a, .b]
        nav.apply(.forwardAndReplace(.c), to: &stack)
        #expect(stack == [.a, .c])
    }

    @Test
    func forwardAndReplace_on_empty_acts_like_push() {
        var stack: [TestRoute] = []
        nav.apply(.forwardAndReplace(.a), to: &stack)
        #expect(stack == [.a])
    }

    @Test
    func rewind_truncates_after_target_when_found() {
        var stack: [TestRoute] = [.a, .b, .c, .d]
        nav.apply(.rewind(.b), to: &stack)
        #expect(stack == [.a, .b])
        // Rewind to first
        nav.apply(.rewind(.a), to: &stack)
        #expect(stack == [.a])
    }

    @Test
    func rewind_noop_when_target_not_found() {
        var stack: [TestRoute] = [.a, .b]
        nav.apply(.rewind(.c), to: &stack)
        #expect(stack == [.a, .b])
    }
}

