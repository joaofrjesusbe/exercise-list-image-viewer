import SwiftUI
import AppGroup

@MainActor
protocol ImageInfoUIAdaptable {
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCellItem
    
    func toUserString(_ imageInfo: ImageInfo) -> LocalizedStringResource
    
    func toLikesString(_ imageInfo: ImageInfo) -> LocalizedStringResource
}

extension ImageInfoUIAdaptable {
    
    func toArrayCellItems(_ array: [ImageInfo]) -> [DSListCellItem] {
        array.map(toCellItem(_:))
    }
}

struct ImageInfoUIAdapter: ImageInfoUIAdaptable {
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCellItem {
        DSListCellItem(
            id: String(imageInfo.id),
            title: toUserString(imageInfo),
            description: toLikesString(imageInfo),
            icon: URL(string: imageInfo.previewURL)
        )
    }
    
    func toUserString(_ imageInfo: ImageInfo) -> LocalizedStringResource {
        L10n.user(imageInfo.user)
    }
    
    func toLikesString(_ imageInfo: ImageInfo) -> LocalizedStringResource {
        L10n.likes(imageInfo.likes)        
    }
}
