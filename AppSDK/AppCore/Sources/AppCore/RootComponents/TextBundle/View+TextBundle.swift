import SwiftUI

// MARK: - Button + TextBundle
@MainActor
public extension Button where Label == TextBundle {
    init(
        _ title: LocalizedStringResource,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.init(role: role, action: action) {
            TextBundle(title)
        }
    }
}

// MARK: - Toggle + TextBundle
@MainActor
public extension Toggle where Label == TextBundle {
    init(
        _ title: LocalizedStringResource,
        isOn: Binding<Bool>
    ) {
        self.init(isOn: isOn) {
            TextBundle(title)
        }
    }
}

// MARK: - ProgressView + TextBundle

// Title only
@MainActor
public extension ProgressView where Label == TextBundle, CurrentValueLabel == EmptyView {
    init(_ title: LocalizedStringResource) {
        self.init {
            TextBundle(title)
        }
    }
    
    init(
        _ title: LocalizedStringResource,
        value: Double,
        total: Double = 1.0
    ) {
        self.init(value: value, total: total) {
            TextBundle(title)
        }
    }
}

// Title + current value label
@MainActor
public extension ProgressView where Label == TextBundle, CurrentValueLabel == TextBundle {
    init(
        _ title: LocalizedStringResource,
        currentValueLabel current: LocalizedStringResource,
        value: Double,
        total: Double = 1.0
    ) {
        self.init(
            value: value,
            total: total,
            label: { TextBundle(title) },
            currentValueLabel: { TextBundle(current) }
        )
    }
}

// MARK: - Picker + TextBundle (non-optional selection)
@MainActor
public extension Picker where Label == TextBundle {
    init(
        _ title: LocalizedStringResource,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content
    ) {
        self.init(selection: selection, content: content) {
            TextBundle(title)
        }
    }
}

// MARK: - Picker + TextBundle (optional selection)
@MainActor
public extension Picker where Label == TextBundle {
    init<V>(
        _ title: LocalizedStringResource,
        selection: Binding<V?>,
        @ViewBuilder content: () -> Content
    ) where SelectionValue == V? {
        self.init(selection: selection, content: content) {
            TextBundle(title)
        }
    }
}

// MARK: - Section + TextBundle (header only)
@MainActor
public extension SwiftUI.Section where Parent == TextBundle, Footer == EmptyView, Content: View {
    init(
        _ header: LocalizedStringResource,
        @ViewBuilder content: () -> Content
    ) {
        self.init(content: content, header: { TextBundle(header) })
    }
}

// MARK: - Section + TextBundle (header + footer)
@MainActor
public extension SwiftUI.Section where Parent == TextBundle, Footer == TextBundle, Content: View {
    init(
        _ header: LocalizedStringResource,
        footer: LocalizedStringResource,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            content: content,
            header: { TextBundle(header) },
            footer: { TextBundle(footer) }
        )
    }
}

// MARK: - Section + TextBundle (footer only)
@MainActor
public extension SwiftUI.Section where Parent == EmptyView, Footer == TextBundle, Content: View {
    init(
        footer: LocalizedStringResource,
        @ViewBuilder content: () -> Content
    ) {
        self.init(content: content, footer: { TextBundle(footer) })
    }
}

// MARK: - Label + TextBundle (generic icon)
@MainActor
public extension Label where Title == TextBundle {
    init(
        _ title: LocalizedStringResource,
        @ViewBuilder icon: () -> Icon
    ) {
        self.init(title: { TextBundle(title) }, icon: icon)
    }
}

// MARK: - Label + TextBundle (SF Symbol icon)
@MainActor
public extension Label where Title == TextBundle, Icon == Image {
    init(
        _ title: LocalizedStringResource,
        systemImage: String
    ) {
        self.init(title: { TextBundle(title) }) {
            Image(systemName: systemImage)
        }
    }
    
    init(
        _ title: LocalizedStringResource,
        image: String
    ) {
        self.init(title: { TextBundle(title) }) {
            Image(image)
        }
    }
}

// MARK: - Label + TextBundle (title-only convenience)
@MainActor
public extension Label where Title == TextBundle, Icon == EmptyView {
    init(_ title: LocalizedStringResource) {
        self.init(title: { TextBundle(title) }, icon: { EmptyView() })
    }
}

