import Foundation

public enum L10n {
    
    public static func user(_ name: String) -> LocalizedStringResource {
        LocalizedStringResource(
            "images.user",
            defaultValue: "User: \(name)",
            bundle: .atURL(Bundle.module.bundleURL),
            comment: "Label user of the image"
        )
    }
    
    public static func likes(_ likes: Int) -> LocalizedStringResource {
        LocalizedStringResource(
            "images.likes",
            defaultValue: "Likes: \(likes)",
            bundle: .atURL(Bundle.module.bundleURL),
            comment: "Label number of likes of the image"
        )
    }
    
    public static let listTitle = LocalizedStringResource(
        "images.list.title",
        defaultValue: "Images",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Tabbar title for images"
    )

    public static let detailTitle = LocalizedStringResource(
        "images.detail.title",
        defaultValue: "Image Detail",
        bundle: .atURL(Bundle.module.bundleURL),
        comment: "Tabbar and Navigation title for image detail"
    )
}
