import SwiftUI
import DesignSystem
import PixbayNetwork

protocol ImageInfoUIAdaptable {
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item
    
    func toUserString(_ imageInfo: ImageInfo) -> String
    
    func toLikesString(_ imageInfo: ImageInfo) -> String
}

struct ImageInfoUIAdapter: ImageInfoUIAdaptable {
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item {
        DSListCell.Item(
            id: String(imageInfo.id),
            title: toUserString(imageInfo),
            description: toLikesString(imageInfo),
            icon: URL(string: imageInfo.previewURL)
        )
    }
    
    func toUserString(_ imageInfo: ImageInfo) -> String {
        "User: \(imageInfo.user)"
    }
    
    func toLikesString(_ imageInfo: ImageInfo) -> String {
        "Likes: \(imageInfo.likes)"
    }
}
