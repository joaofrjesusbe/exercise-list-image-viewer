import SwiftUI
import AppGroup

public struct MainNavigation: View {
    @EnvironmentObject private var themer: ThemeManager
    private let tabs: [AnyNavigationRepresentable]
    @Binding private var selection: Int
    
    public init(tabs: [AnyNavigationRepresentable], selection: Binding<Int>) {
        self.tabs = tabs
        self._selection = selection
    }
    
    public var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs.indices, id: \.self) { index in
                tabs[index]
                    .tabItem {
                        Label(
                            tabs[index].navigationItem.text,
                            systemImage: tabs[index].navigationItem.icon
                        )
                    }
                    .tag(index)
                    .background(themer.theme.background)
            }
        }
        .background(themer.theme.background)
    }
}
