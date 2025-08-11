import SwiftUI
import AppCore

public struct MainNavigation: View {
    private let tabs: [AnyNavigationRepresentable]
    @State public private(set) var selection: Int = 0
    
    public init(tabs: [AnyNavigationRepresentable], initialIndex: Int = 0) {
        self.tabs = tabs
        self._selection = State(initialValue: min(max(0, initialIndex), max(0, tabs.count - 1)))
    }
    
    public var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs.indices, id: \.self) { index in
                tabs[index]
                    .tabItem {
                        Label {
                            Text(tabs[index].navigationItem.text)
                        } icon: {
                            Image(systemName: tabs[index].navigationItem.icon)
                        }
                    }
                    .tag(index)
            }
        }
    }
}
