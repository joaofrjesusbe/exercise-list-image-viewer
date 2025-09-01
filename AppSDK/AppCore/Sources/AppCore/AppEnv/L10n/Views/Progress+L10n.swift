import SwiftUI

// 1) Determinate with BOTH labels
@MainActor
public extension ProgressView where Label == Localized2Text, CurrentValueLabel == Localized2Text {
    init(_ key: L10n.Key, value: Double, total: Double = 1.0, currentValueKey: L10n.Key) {
        self.init(value: value, total: total) {
            Localized2Text(key)
        } currentValueLabel: {
            Localized2Text(currentValueKey)
        }
    }
}

// 2) Determinate with ONLY the main label (current value label is EmptyView)
@MainActor
public extension ProgressView where Label == Localized2Text, CurrentValueLabel == EmptyView {
    init(_ key: L10n.Key, value: Double, total: Double = 1.0) {
        self.init(value: value, total: total) {
            Localized2Text(key)
        }
    }
}

// (Optional) Indeterminate with just a label
@MainActor
public extension ProgressView where Label == Localized2Text, CurrentValueLabel == EmptyView {
    init(_ key: L10n.Key) {
        self.init { Localized2Text(key) }
    }
}
