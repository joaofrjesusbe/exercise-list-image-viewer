import Foundation
import ImageIO
import ImageDS

struct MapImageInfo {
    
    static func toCell(_ imageInfo: ImageInfo) -> DSListCell.Input {
        DSListCell.Input(
            id: String(imageInfo.id),
            title: toUser(imageInfo),
            description: toLikes(imageInfo),
            icon: URL(string: imageInfo.previewURL)
        )
    }
    
    static func toUser(_ imageInfo: ImageInfo) -> String {
        "User: \(imageInfo.user)"
    }
    
    static func toLikes(_ imageInfo: ImageInfo) -> String {
        "Likes: \(imageInfo.likes)"
    }
}
