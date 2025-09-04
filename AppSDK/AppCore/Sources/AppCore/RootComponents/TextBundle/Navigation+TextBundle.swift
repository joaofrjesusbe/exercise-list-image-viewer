import SwiftUI

public extension View {
    func navigationTitle(_ resource: LocalizedStringResource) -> some View {
        self.toolbar {
            ToolbarItem(placement: .principal) {
                TextBundle(resource) // your custom view that respects override bundles
            }
        }
    }
}
