@testable import AppCore
import Foundation
import Testing

@MainActor
final class TextBundleFactoryTests: @unchecked Sendable {

    @Test
    func override_bundle_is_used_when_key_exists() {
        // Given a resource key present in test bundle's Localizable.strings
        let key = "greeting"
        let resource = LocalizedStringResource(String.LocalizationValue(key))

        // When resolving with test bundle as an override
        let factory = TextBundleFactory(resource: resource,
                                        locale: Locale(identifier: "en"),
                                        overrideBundles: [Bundle.module])
        let resolved = factory.findOverwriteResource()

        // Then String(localized:) should yield the override value from the test bundle
        let value = String(localized: resolved)
        #expect(value == "Hello from override")
    }

    @Test
    func falls_back_to_original_when_override_missing_key() {
        // Given a key not present in the override bundle
        let key = "missing_key"
        let resource = LocalizedStringResource(String.LocalizationValue(key))

        let factory = TextBundleFactory(resource: resource,
                                        locale: Locale(identifier: "en"),
                                        overrideBundles: [Bundle.module])
        let resolved = factory.findOverwriteResource()

        // Expect fallback to original resource; String(localized:) returns the key
        let value = String(localized: resolved)
        #expect(value == key)
    }

    @Test
    func respects_table_name_when_specified() {
        // Given a key present in Custom.strings
        let key = "custom_key"
        let resource = LocalizedStringResource(
            String.LocalizationValue(key),
            table: "Custom"
        )

        let factory = TextBundleFactory(resource: resource,
                                        locale: Locale(identifier: "en"),
                                        overrideBundles: [Bundle.module])
        let resolved = factory.findOverwriteResource()

        let value = String(localized: resolved)
        #expect(value == "Custom Override")
    }
}

