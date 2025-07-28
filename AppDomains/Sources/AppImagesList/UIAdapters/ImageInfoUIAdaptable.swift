import SwiftUI
import DesignSystem
import PixbayNetwork
import AppCore

@MainActor
protocol ImageInfoUIAdaptable {
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item
    
    func toUserString(_ imageInfo: ImageInfo) -> String
    
    func toLikesString(_ imageInfo: ImageInfo) -> String
}

extension ImageInfoUIAdaptable {
    
    func toArrayCellItems(_ array: [ImageInfo]) -> [DSListCell.Item] {
        array.map(toCellItem(_:))
    }
}

struct ImageInfoUIAdapter: ImageInfoUIAdaptable {
    private let languageManager: LanguageManager
    
    init() {
        self.languageManager = LanguageManagerKey.defaultValue
    }
    
    func toCellItem(_ imageInfo: ImageInfo) -> DSListCell.Item {
        DSListCell.Item(
            id: String(imageInfo.id),
            title: toUserString(imageInfo),
            description: toLikesString(imageInfo),
            icon: URL(string: imageInfo.previewURL)
        )
    }
    
    func toUserString(_ imageInfo: ImageInfo) -> String {
        "\(L10n.user): \(imageInfo.user)"
    }
    
    func toLikesString(_ imageInfo: ImageInfo) -> String {
        "\(L10n.likes): \(imageInfo.likes)"
    }
}
