import SwiftUI

// MARK: - Button
@MainActor
public extension Button where Label == Localized2Text {
    init(_ key: L10n.Key, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.init(role: role, action: action) { Localized2Text(key) }
    }
}

// MARK: - (Nice to have) Toggle & Label too
@MainActor
public extension Toggle where Label == Localized2Text {
    init(_ key: L10n.Key, isOn: Binding<Bool>) {
        self.init(isOn: isOn) { Localized2Text(key) }
    }
}

@MainActor
public extension Label where Title == Localized2Text, Icon == Image {
    init(_ key: L10n.Key, systemImage: String) {
        self.init {
            Localized2Text(key)
        } icon: {
            Image(systemName: systemImage)
        }
    }
}
