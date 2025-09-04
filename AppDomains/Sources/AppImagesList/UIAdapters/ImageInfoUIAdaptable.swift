import SwiftUI
import DesignSystem
import PixbayNetwork
import AppCore

@MainActor
protocol ImageInfoUIAdaptable {
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item
    
    func toUserString(_ imageInfo: ImageInfo) -> LocalizedStringResource
    
    func toLikesString(_ imageInfo: ImageInfo) -> LocalizedStringResource
}

extension ImageInfoUIAdaptable {
    
    func toArrayCellItems(_ array: [ImageInfo]) -> [DSListCell.Item] {
        array.map(toCellItem(_:))
    }
}

struct ImageInfoUIAdapter: ImageInfoUIAdaptable {
    private let languageManager: LanguageManager
    
    init() {
        self.languageManager = AppEnvironmentKey.defaultValue.languageManager
    }
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item {
        DSListCell.Item(
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
