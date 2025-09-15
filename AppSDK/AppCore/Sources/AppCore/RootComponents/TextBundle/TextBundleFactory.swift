import Foundation
import SwiftUI

public struct TextBundleFactory {
    private let resource: LocalizedStringResource
    private let locale: Locale
    private let overrideBundles: [Bundle]
    
    public init(resource: LocalizedStringResource, locale: Locale, overrideBundles: [Bundle]) {
        self.resource = resource
        self.locale = locale
        self.overrideBundles = overrideBundles
    }
    
    public func callAsFunction() -> Text {
        createTextView()
     }
    
    public func createTextView() -> Text {
        Text(findOverwriteResource())
    }
    
    public func findOverwriteResource() -> LocalizedStringResource {
        for bundle in overrideBundles {
            // Try to resolve using this override bundle
            let candidate = bundle.localizedString(
                forKey: resource.key,
                value: nil,
                table: resource.table
            )
            
            // If the override produces something different from the default,
            // treat it as an override hit.
            if candidate != resource.key {
                return LocalizedStringResource(
                    String.LocalizationValue(resource.key),
                    table: resource.table,
                    bundle: .atURL(bundle.bundleURL)
                )
            }
        }
        
        // Fallback to the original resource
        return resource
    }
}
