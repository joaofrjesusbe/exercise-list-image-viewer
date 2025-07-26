import SwiftUI
import DesignSystem
import PixbayNetwork

struct ImagesInfoUIAdapter {
    
    static func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item {
        DSListCell.Item(
            id: String(imageInfo.id),
            title: toUserString(imageInfo),
            description: toLikesString(imageInfo),
            icon: URL(string: imageInfo.previewURL)
        )
    }
    
    static func toUserString(_ imageInfo: ImageInfo) -> String {
        "User: \(imageInfo.user)"
    }
    
    static func toLikesString(_ imageInfo: ImageInfo) -> String {
        "Likes: \(imageInfo.likes)"
    }
}
