import SwiftUI

public struct AnyNavigationRepresentable: NavigationRepresentable {
    private let _navigationItem: () -> NavigationItem   // may need to be escaping
    private let _body: AnyView                           // store value, not closure

    /// Erase any `NavigationRepresentable`
    public init<Base: NavigationRepresentable>(_ base: Base) {
        self._navigationItem = { base.navigationItem }
        self._body = AnyView(base)
    }

    /// Dynamic nav item + custom content
    public init(
        navigationItem: @escaping () -> NavigationItem,
        @ViewBuilder content: () -> some View
    ) {
        self._navigationItem = navigationItem
        self._body = AnyView(content())                  // build now
    }

    /// Static nav item + custom content
    public init(
        navigationItem: NavigationItem,
        @ViewBuilder content: () -> some View
    ) {
        self._navigationItem = { navigationItem }
        self._body = AnyView(content())                  // build now
    }

    public var navigationItem: NavigationItem { _navigationItem() }
    public var body: some View { _body }
}

public extension NavigationRepresentable {
    func eraseToAnyNavigation() -> AnyNavigationRepresentable {
        AnyNavigationRepresentable(self)
    }
}
